
#import "UtilityClass.h"

@implementation UtilityClass


#pragma mark -
#pragma mark - Init And Shared Object

-(id) init{
    if((self = [super init])){
        
    }
    return self;
}

+ (UtilityClass *)sharedObject
{
    static UtilityClass *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[UtilityClass alloc] init];
    });
    return objUtility;
}

#pragma mark -
#pragma mark - Distance convertion methods

-(double)meterToKilometer:(double)meter
{
    double kilometer=meter/1000;
    return kilometer;
}
-(double)kilometerToMeter:(double)kilometer
{
    double meter=kilometer*1000;
    return meter;
}
-(double)meterToMiles:(double)meter
{
    double miles=meter * 0.00062137119;
    return miles;
}
-(double)milesToMeter:(double)miles
{
    double meter=miles/0.00062137119;
    return meter;
}
-(double)kilometerToMiles:(double)kilometer
{
    double miles=kilometer * 0.62137;
    return miles;
}
-(double)milesToKilometer:(double)miles
{
    double kilometer=miles/0.62137;
    return kilometer;
}

#pragma mark -
#pragma mark - String Utillity Functions

-(NSString*) trimString:(NSString *)theString
{
	NSString *theStringTrimmed = [theString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return theStringTrimmed;
}

-(NSString *) removeNull:(NSString *) string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
	NSRange range = [string rangeOfString:@"null"];
	if (range.length > 0 || string == nil) {
		string = @"";
	}
	string = [self trimString:string];
	return string;
}

#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationDocumentDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}

- (NSURL *)applicationDocumentsDirectoryURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

# pragma mark -
# pragma mark - Scale and Rotate according to Orientation

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            
            // landscape right
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            
            // landscape left
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            
            // Portrait Mode
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

-(BOOL)isValidEmailAddress:(NSString *)email
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString:laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
-(BOOL)isvalidPassword:(NSString *)password
{
    if (password.length<8) {
        return NO;
    }
    NSRange upperCaseRange;
    NSCharacterSet *upperCaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    
    upperCaseRange = [password rangeOfCharacterFromSet: upperCaseSet];
    if (upperCaseRange.location == NSNotFound)
    {
        return NO;
    }
    if ([password rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location!=NSNotFound)
    {
        return NO;
    }
    if ([password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location==NSNotFound) {
        return NO;
    }
    NSString *specialCharacters = @"!#€%&/()[]=?$§*'@";
    if ([password rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]].location!=NSNotFound) {
        return NO;
    }
    return YES;
}


#pragma mark -
#pragma mark - Alert Helper

//-(void)showAlertWithTitle:(NSString *)strTitle andMessage:(NSString *)strMsg
//{
//    UIAlertView *alret=[[UIAlertView alloc]initWithTitle:strTitle message:strMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//    [alret show];
//}

#pragma mark -
#pragma mark - datetime helper

- (NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString: dateString];
    return date;
}

- (NSDate *)stringToDate:(NSString *)dateString withFormate:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString: dateString];
    return date;
}

- (NSString *)DateToString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//2013-07-15:10:00:00
    NSString * strdate = [formatter stringFromDate:date];
    return strdate;
}

-(NSString *)DateToString:(NSDate *)date withFormate:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];//2013-07-15:10:00:00
    NSString * strdate = [formatter stringFromDate:date];
    return strdate;
}

-(NSString *)DateToStringForScanQueue:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString * strdate = [formatter stringFromDate:date];
    int dd=[[self trimString:strdate]intValue];
    NSString *format=@"";
    if (dd==1 || dd==21 || dd==31) {
        format=@"ddst MMMM yyyy, hh:mm:ss a";
    }
    else if (dd==2 || dd==22)
    {
        format=@"ddnd MMMM yyyy, hh:mm:ss a";
    }
    else if (dd==3)
    {
        format=@"ddrd MMMM yyyy, hh:mm:ss a";
    }
    else{
        format=@"ddth MMMM yyyy, hh:mm:ss a";
    }
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:format];
    strdate= [formatter2 stringFromDate:date];
    return strdate;
}

-(NSString *)DateToString:(NSDate *)date withFormateSufix:(NSString *)format{
    
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:format];
    NSString * prefixDateString = [prefixDateFormatter stringFromDate:date];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    
    prefixDateString = [prefixDateString stringByReplacingOccurrencesOfString:@"." withString:suffix];
    NSString *dateString =prefixDateString;
    
    return dateString;
}

-(int)dateDiffrenceFromDateInString:(NSString *)date1 second:(NSString *)date2
{
    // Manage Date Formation same for both dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *startDate = [formatter dateFromString:date1];
    NSDate *endDate = [formatter dateFromString:date2];
    
    
    unsigned flags = NSCalendarUnitDay;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    int dayDiff = (int)[difference day];
    
    return dayDiff;
}

-(int)dateDiffrenceFromDate:(NSDate *)startDate second:(NSDate *)endDate
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    unsigned flags = NSCalendarUnitDay;
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
    
    int dayDiff = (int)[difference day];
    if (dayDiff<1) {
        int hourDiff=(int)[difference hour];
        if (hourDiff>12) {
            return 1;
        }
    }
    return dayDiff;
}

#pragma mark -
#pragma mark - Tableview Helper

-(void)setTableViewHeightWithNoLine:(UITableView *)tbl
{
    CGRect rectTbl=tbl.frame;
    if (rectTbl.size.height>tbl.contentSize.height) {
        rectTbl.size.height=tbl.contentSize.height;
        tbl.scrollEnabled=FALSE;
    }
    else{
        tbl.scrollEnabled=TRUE;
    }
    [tbl setFrame:rectTbl];
}

#pragma mark -
#pragma mark - BarButtonItem Helper

-(UIBarButtonItem *)setBackbarButtonWithName:(NSString *)strName
{
    return [[UIBarButtonItem alloc] initWithTitle:strName style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
