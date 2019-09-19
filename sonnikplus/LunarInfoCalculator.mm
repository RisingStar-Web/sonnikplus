//
//  LunarInfoCalculator.m
//  sonnikplus
//
//  Created by neko on 15.03.13.
//  Copyright (c) 2013 denisalfa. All rights reserved.
//

#import "LunarInfoCalculator.h"
#import "AA+.h"
#import "moonstuff.h"
#import "swephexp.h"

@implementation LunarInfoCalculator

static double geopos[3]; /* Геопозиция текущая* 0 - longitude, 1 - latitude, 2 - высота над уровнем моря */
static int year, month, day, hour, min;
static double sec;
static int moonImage;
static double tjd_ut;
static double moonIlluminaty;
const char *moonPhase;
static bool moonRise;
static long mryy,mrmm,mrdd,mrhh,mrmin,msyy,msmm,msdd,mshh,msmin;
static double mrsec,mssec;
static double x[6];
static char *zod_nam[] = {(char*)"Овен", (char*)"Телец", (char*)"Близнецы", (char*)"Рак", (char*)"Лев", (char*)"Дева",
    (char*)"Весы", (char*)"Скорпион", (char*)"Стрелец", (char*)"Козерог", (char*)"Водолей", (char*)"Рыбы"};
const char *zodname;
static int zdeg,zmin;

static char *dms(double xv, int32 iflag);

static char *dms(double xv, int32 iflg)
{
    int izod;
    int32 k, kdeg, kmin, ksec;
    char s1[50];
    static char s[50];
    int sgn;
    *s = '\0';
    if (xv < 0) {
        xv = -xv;
        sgn = -1;
    } else
        sgn = 1;
    izod = (int) (xv / 30);
    xv = fmod(xv, 30);
    kdeg = (int32) xv;
//    sprintf(s, "%2d %s ", kdeg, zod_nam[izod]);
    zodname = zod_nam[izod];
    xv -= kdeg;
    xv *= 60;
    kmin = (int32) xv;
//    sprintf(s1, "%2d'", kmin);
    zdeg = kdeg;
    zmin = kmin;
    strcat(s, s1);
    xv -= kmin;
    xv *= 60;
    ksec = (int32) xv;
//    sprintf(s1, "%2d", ksec);
    strcat(s, s1);
    xv -= ksec;
    k = (int32) (xv * 10000);
//    sprintf(s1, ".%04d", k);
    strcat(s, s1);
    return(s);
}

- (double)julDay:(int)year mont:(int)month day:(int)day {
	if (year < 0) { year ++; }
	int jy = year;
	int jm = month +1;
	if (month <= 2) {jy--;	jm += 12;	}
	double jul = floor(365.25 *jy) + floor(30.6001 * jm) + day + 1720995;
	if (day+31*(month+12*year) >= (15+31*(10+12*1582))) {
		double ja = floor(0.01 * jy);
		jul = jul + 2 - ja + floor(0.25 * ja);
	}
	return jul;
}

- (NSMutableDictionary *) mainComputations {
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    /*--- Вычисляем Юлианскую дату (до секунд). Записываем в переменную tjd_ut */
    int32 gregflag = SE_GREG_CAL;
    double d_timezone = 0 ;
    
    double dret[2];
    char serr[256];
    int32 iyear_utc, imonth_utc, iday_utc, ihour_utc, imin_utc;
    double dsec_utc;
    
    swe_utc_time_zone(year, month, day, hour, min, sec, d_timezone, &iyear_utc, &imonth_utc, &iday_utc, &ihour_utc, &imin_utc, &dsec_utc);
    /* calculate Julian day number in UT (UT1) and ET (TT) from UTC */
    swe_utc_to_jd (iyear_utc, imonth_utc, iday_utc, ihour_utc, imin_utc, dsec_utc, gregflag, dret, serr);
    
    tjd_ut = dret[1];
    [tempDict setValue:[NSNumber numberWithFloat:tjd_ut] forKey:@"julianDateUT"];
    /*-----------------------------------------------------*/
    
    /*--- Вычисляем полнолуния и новолуния (одно до, и одно после текущей даты) ---*/
    //getCurMoonPhase(c1,c2,c3,c4);
    calendar c1,c2,c3,c4;
	getThisMoonPhase(day,month,year,c1,c2,c3,c4);
//    printf("Прошедшее новолуние: %i.%i.%i %i:%i:%i\n",c1.yy,c1.mm,c1.dd,c1.hr,c1.min,c1.sec);
//    printf("Ближайшее новолуние: %i.%i.%i %i:%i:%i\n",c2.yy,c2.mm,c2.dd,c2.hr,c2.min,c2.sec);
//    printf("Прошедшее полнолуние: %i.%i.%i %i:%i:%i\n",c3.yy,c3.mm,c3.dd,c3.hr,c3.min,c3.sec);
//    printf("Ближайшее полнолуние: %i.%i.%i %i:%i:%i\n",c4.yy,c4.mm,c4.dd,c4.hr,c4.min,c4.sec);
    [tempDict setValue:[NSString stringWithFormat:@"%i-%i-%i %i:%i:%i",c1.yy,c1.mm,c1.dd,c1.hr,c1.min,c1.sec] forKey:@"newMoonPast"];
    [tempDict setValue:[NSString stringWithFormat:@"%i-%i-%i %i:%i:%i",c2.yy,c2.mm,c2.dd,c2.hr,c2.min,c2.sec] forKey:@"newMoonFuture"];
    [tempDict setValue:[NSString stringWithFormat:@"%i-%i-%i %i:%i:%i",c3.yy,c3.mm,c3.dd,c3.hr,c3.min,c3.sec] forKey:@"fullMoonPast"];
    [tempDict setValue:[NSString stringWithFormat:@"%i-%i-%i %i:%i:%i",c4.yy,c4.mm,c4.dd,c4.hr,c4.min,c4.sec] forKey:@"fullMoonFuture"];
    
    /*--------------------------------------------------------*/
    /*---- Восход/закат на текущую дату. Освещенная часть ---*/
    PrintSunAndMoonInfo(-geopos[0], geopos[1]);
    [tempDict setValue:[NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02f",mryy, mrmm, mrdd, mrhh, mrmin, mrsec] forKey:@"moonRise"];
    [tempDict setValue:[NSString stringWithFormat:@"%ld-%ld-%ld %02ld:%02ld:%02f",msyy, msmm, msdd, mshh, msmin, mssec] forKey:@"moonSet"];
    [tempDict setValue:[NSNumber numberWithFloat:moonIlluminaty] forKey:@"illuminaty"];
    [tempDict setValue:[NSString stringWithUTF8String:moonPhase] forKey:@"moonPhase"];
    [tempDict setValue:[NSNumber numberWithBool:moonRise] forKey:@"moonRiseState"];
    [tempDict setValue:[NSNumber numberWithInt:moonImage] forKey:@"moonImage"];
    
    
    /*--------------------------------------------------------*/
    swe_set_topo(geopos[0], geopos[1], geopos[2]);
    swe_calc_ut(tjd_ut, 1, 2, x, nil);
    
    dms(x[0], 4);

    /*---- Возраст луны ---*/
    //double IP = [self normalize:(tjd_ut - 2451550.1 ) / 29.530588853];
    double sunx[6];
    swe_calc_ut(tjd_ut, 0, 2, sunx, nil);
    double sunmoon = x[0] - sunx[0];
    if (sunmoon < 0) sunmoon = sunmoon + 360.0;
    double mday = sunmoon/12 + 1;

    //    int32 iyear, imonth, iday, ihour, imin;
    //    double dsec;
    //    printf("%f",jd);
    //    swe_jdut1_to_utc(jd, 0, &iyear, &imonth, &iday, &ihour, &imin, &dsec);
    //    printf("\nЛунный день начался: %i %i:%i:%f", iday,ihour,imin,dsec);
    [tempDict setValue:[NSNumber numberWithFloat:mday] forKey:@"moonDay"];
//    printf("\nЛунный день: %f",mday);
    /*--------------------------------------------------------*/
//    printf("\n");
    
    
    [tempDict setValue:[NSString stringWithUTF8String:zodname] forKey:@"zodiacName"];
    [tempDict setValue:[NSString stringWithUTF8String:zodname] forKey:@"zodiacName"];
    [tempDict setValue:[NSString stringWithFormat:@"%iº%i'",zdeg,zmin] forKey:@"zodiacPos"];
    
    swe_close();
    
    return tempDict;
}

-(double)GetFrac:(double)fr {	return (fr - floor(fr));}
//global variables to hold the calendar dates returned

- (NSDictionary *)initWithGeoposAndDate:(int)outYear month:(int)outMonth day:(int)outDay hours:(int)outHours minutes:(int)outMinutes seconds:(double)outSeconds longitude:(double)longitude latitude:(double)latitude {
    year = outYear;
    month = outMonth;
    day = outDay;
    hour = outHours;
    min = outMinutes;
    sec = outSeconds;
    geopos[0] = longitude;
    geopos[1] = latitude;
    geopos[2] = 0.0;
    NSDictionary *resDict = [[NSDictionary alloc] initWithDictionary:[self mainComputations]];
    return resDict;
}

void GetLunarRaDecByJulian(double JD, double& RA, double& Dec)
{
    double lambda = CAAMoon::EclipticLongitude(JD);
    double beta = CAAMoon::EclipticLatitude(JD);
    double epsilon = CAANutation::TrueObliquityOfEcliptic(JD);
    CAA2DCoordinate Lunarcoord = CAACoordinateTransformation::Ecliptic2Equatorial(lambda, beta, epsilon);
    RA = Lunarcoord.X;
    Dec = Lunarcoord.Y;
}

void GetSolarRaDecByJulian(double JD, double& RA, double& Dec)
{
    double JDSun = JD + CAADynamicalTime::DeltaT(JD) / 86400.0;
    double lambda = CAASun::ApparentEclipticLongitude(JDSun);
    double beta = CAASun::ApparentEclipticLatitude(JDSun);
    double epsilon = CAANutation::TrueObliquityOfEcliptic(JD);
    CAA2DCoordinate Solarcoord = CAACoordinateTransformation::Ecliptic2Equatorial(lambda, beta, epsilon);
    RA = Solarcoord.X;
    Dec = Solarcoord.Y;
}

CAARiseTransitSetDetails GetMoonRiseTransitSet(double JD, double longitude, double latitude)
{
    double alpha1 = 0;
    double delta1 = 0;
    GetLunarRaDecByJulian(JD - 1, alpha1, delta1);
    double alpha2 = 0;
    double delta2 = 0;
    GetLunarRaDecByJulian(JD, alpha2, delta2);
    double alpha3 = 0;
    double delta3 = 0;
    GetLunarRaDecByJulian(JD + 1, alpha3, delta3);
    return CAARiseTransitSet::Calculate(JD, alpha1, delta1, alpha2, delta2, alpha3, delta3, longitude, latitude, 0.125);
}

void PrintMoonIlluminationAndPhase()
{
    double illuminated_fraction = 0;
    double position_angle = 0;
    double phase_angle = 0;
    GetMoonIllumination(illuminated_fraction, position_angle, phase_angle);
//    printf("Moon illumination: %f%%\n", illuminated_fraction * 100);
    moonIlluminaty = illuminated_fraction;
    double phase(position_angle < 180 ? phase_angle + 180 : 180 - phase_angle);
    if ((phase >= 0 && phase < 5) || phase >= 355) {
//        printf("Новолуние");
        moonPhase = "Новолуние";
        moonImage = 0;
        moonRise = TRUE;
    }
    else if (phase > 5 && phase < 85)
    {
//        printf("Растущая луна. 1 четверть.");
        moonPhase = "1 четверть";
        moonImage = 1;
        moonRise = TRUE;
    }
    else if (phase >= 85 && phase <= 95)
    {
//        printf("Растущая луна. 2 четверть.");
        moonPhase = "2 четверть";
        moonRise = TRUE;
        moonImage = 2;
    }
    else if (phase > 95 && phase < 175)
    {
//        printf("Растущая луна. 2 четверть.");
        moonPhase = "2 четверть";
        moonRise = TRUE;
        moonImage = 3;
    }
    else if (phase >= 175 && phase <= 185) {
//        printf("Полнолуние");
        moonPhase = "Полнолуние";
        moonRise = FALSE;
        moonImage = 4;
    }

    else if (phase > 185 && phase < 265)
    {
//        printf("Убывающая луна. 3 четверть.");
        moonPhase = "3 четверть";
        moonRise = FALSE;
        moonImage = 5;

    }
    else if (phase >= 265 && phase < 275)
    {
//        printf("Растущая луна. 2 четверть.");
        moonPhase = "2 четверть";
        moonRise = TRUE;
        moonImage = 6;
    }

    else if (phase >= 275 && phase < 355)
    {
//        printf("Убывающая луна. 4 четверть.");
        moonPhase = "4 четверть";
        moonRise = FALSE;
        moonImage = 7;
    }
}

void ASCIIPlot(char* buf, int buf_w, int x, int y, bool b)
{
    buf[x + y * buf_w] = b ? 'X' : ' ';
}

void DrawFilledEllipse(char* buf, int buf_w, int c_x, int c_y, int w, int h, bool half_l, bool half_r, bool b)
{
    int hh = h * h;
    int ww = w * w;
    int hhww = hh * ww;
    int x0 = w;
    int dx = 0;
    
    //do the horizontal diameter
    if (half_l)
    {
        for (int x = 0; x <= w; x++)
            ASCIIPlot(buf, buf_w, c_x - x, c_y, b);
    }
    if (half_r)
    {
        for (int x = -w; x <= 0; x++)
            ASCIIPlot(buf, buf_w, c_x - x, c_y, b);
    }
    //now do both halves at the same time, away from the diameter
    for (int y = 1; y <= h; y++)
    {
        int x1 = x0 - (dx - 1);  //try slopes of dx - 1 or more
        for ( ; x1 > 0; x1--)
        {
            if (x1*x1*hh + y*y*ww <= hhww)
                break;
        }
        dx = x0 - x1;  // current approximation of the slope
        x0 = x1;
        
        for (int x = -x0; x <= x0; x++)
        {
            if ((half_l && x <= 0) || (half_r && x >= 0))
            {
                ASCIIPlot(buf, buf_w, c_x + x, c_y - y, b);
                ASCIIPlot(buf, buf_w, c_x + x, c_y + y, b);
            }
        }
    }
}

double MapRange(double new_min, double new_max, double old_min, double old_max, double old_val)
{
    return (((old_val - old_min) * (new_max - new_min)) / (old_max - old_min)) + new_min;
}

void PrintMoonPhase(double position_angle, double phase_angle)
{
    //Phase:
    //right side illuminated: 0 - 180 degrees
    //left side illuminated:  180 - 360 degrees
    //0 degrees = new moon
    //90 degrees = first quarter (right half illuminated)
    //180 degrees = full moon
    //270 degrees = last quarter (left half illuminated)
    double phase(position_angle < 180 ? phase_angle + 180 : 180 - phase_angle);
    
    const int buf_w = 80;
    const int buf_h = 40;
    char buf[buf_w * buf_h];
    memset(buf, ' ', sizeof(buf));
    
    int center_x = buf_w / 2;
    int center_y = buf_h / 2;
    int radius_w = (buf_w - 1) / 2;
    int radius_h = (buf_h - 1) / 2;
    
    if (phase < 90)
    {
        //round right + cut out right
        DrawFilledEllipse(buf, buf_w, center_x, center_y, radius_w, radius_h, false, true, true);
        DrawFilledEllipse(buf, buf_w, center_x, center_y,
                          static_cast<int>(radius_w * sin(MapRange(M_PI_2, 0.0f, 0.0f, 90.0f, phase))), radius_h,
                          false, true, false);
    }
    else if (phase >= 90 && phase < 180)
    {
        //round right + addition left
        DrawFilledEllipse(buf, buf_w, center_x, center_y, radius_w, radius_h, false, true, true);
        DrawFilledEllipse(buf, buf_w, center_x, center_y,
                          static_cast<int>(radius_w * sin(MapRange(0.0f, M_PI_2, 90.0f, 180.0f, phase))), radius_h,
                          true, false, true);
    }
    else if (phase >= 180 && phase < 270)
    {
        //round left + addition right
        DrawFilledEllipse(buf, buf_w, center_x, center_y, radius_w, radius_h, true, false, true);
        DrawFilledEllipse(buf, buf_w, center_x, center_y,
                          static_cast<int>(radius_w * sin(MapRange(M_PI_2, 0.0f, 180.0f, 270.0f, phase))), radius_h,
                          false, true, true);
    }
    else
    {
        //round left + cut out left
        DrawFilledEllipse(buf, buf_w, center_x, center_y, radius_w, radius_h, true, false, true);
        DrawFilledEllipse(buf, buf_w, center_x, center_y,
                          static_cast<int>(radius_w * sin(MapRange(0.0f, M_PI_2, 270.0f, 360.0f, phase))), radius_h,
                          true, false, false);
    }
    
    for (int y=0; y<buf_h; ++y)
    {
//        for (int x=0; x<buf_w; ++x)
//            printf("%c", buf[x + buf_w * y]);
//        printf("\n");
    }
}

void PrintRiseTransitSet(CAARiseTransitSetDetails& rise_transit_set)
{
    
    if (rise_transit_set.bRiseValid)
    {
        double riseJD = (tjd_ut + (rise_transit_set.Rise / 24.00));
        CAADate date_time(riseJD, true);
        date_time.Get(mryy, mrmm, mrdd, mrhh, mrmin, mrsec);
    }
    
    
    if (rise_transit_set.bSetValid)
    {
        double setJD = (tjd_ut + (rise_transit_set.Set / 24.00));
        CAADate date_time(setJD, true);
        date_time.Get(msyy, msmm, msdd, mshh, msmin, mssec);
    }
}

void PrintSunAndMoonInfo(double longitude, double latitude)
{
    CAARiseTransitSetDetails moon_rise_transit_set(GetMoonRiseTransitSet(tjd_ut, longitude, latitude));
    PrintRiseTransitSet(moon_rise_transit_set);
    PrintMoonIlluminationAndPhase();
}

void GetMoonIllumination(double& illuminated_fraction, double& position_angle, double& phase_angle)
{
    double moon_alpha = 0;
    double moon_delta = 0;
    GetLunarRaDecByJulian(tjd_ut, moon_alpha, moon_delta);
    double sun_alpha = 0;
    double sun_delta = 0;
    GetSolarRaDecByJulian(tjd_ut, sun_alpha, sun_delta);
    double geo_elongation = CAAMoonIlluminatedFraction::GeocentricElongation(moon_alpha, moon_delta, sun_alpha, sun_delta);
    
    position_angle = CAAMoonIlluminatedFraction::PositionAngle(sun_alpha, sun_delta, moon_alpha, moon_delta);
    phase_angle = CAAMoonIlluminatedFraction::PhaseAngle(geo_elongation, 368410.0, 149971520.0);
    illuminated_fraction = CAAMoonIlluminatedFraction::IlluminatedFraction(phase_angle);
}

@end
