//
//  MoviesGridViewController.m
//  FlixFind
//
//  Created by Bruke Wossenseged on 6/24/21.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    /*
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies)
                  forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
     */
}

- (void)fetchMovies {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];

    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=83e46c623b2351b9546f239c2f2723b1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
                UIAlertController *alert =
                  [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                   message:@"The Internet connection seems to be offline."
                   preferredStyle:(UIAlertControllerStyleAlert)];
               // create a Try Again action
               UIAlertAction *tryAgainAction =
                  [UIAlertAction actionWithTitle:@"Try Again"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * _Nonnull action) {
                                    [self fetchMovies];
                                                                 }];
               // add the Try Again action to the alertController
               [alert addAction:tryAgainAction];
               [self presentViewController:alert animated:YES completion:^{
                   [activityView stopAnimating];
               }];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.movies = dataDictionary[@"results"];
               for (NSDictionary *movie in self.movies){
                   NSLog(@"%@", movie[@"title"]);
               }
               [activityView stopAnimating];
               [self.collectionView reloadData];
               
           }
       }];
    //[self.refreshControl endRefreshing];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingFormat: posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}


@end
