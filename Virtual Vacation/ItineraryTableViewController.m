//
//  ItineraryTableViewController.m
//  Virtual Vacation
//
//  Created by Michael Mangold on 6/16/12.
//  Copyright (c) 2012 Michael Mangold. All rights reserved.
//

#import "ItineraryTableViewController.h"
#import "Place.h"
#import "VacationPhotosTableViewController.h"

@interface ItineraryTableViewController ()
@property Place *chosenPlace;
@end

@implementation ItineraryTableViewController
@synthesize vacationDocument = _vacationDocument;
@synthesize chosenPlace      = _chosenPlace;

#pragma mark - TableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure cell.
    static NSString *CellIdentifier = @"Itinerary Place Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Execute fetch request and populate cell.
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos", [place.seenIn count]];
    
    return cell;
}

#pragma mark - TableView delegate.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos for Itinerary Place"]) {
        VacationPhotosTableViewController *vacationPhotosTableViewController = segue.destinationViewController;
        vacationPhotosTableViewController.vacationDocument = self.vacationDocument;
        vacationPhotosTableViewController.place            = self.chosenPlace;
        vacationPhotosTableViewController.title            = self.chosenPlace.name;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chosenPlace = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"Show Photos for Itinerary Place" sender:self];
}

#pragma mark CoreDataBableViewController

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"addedDate" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // No predicate because we want all places.
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.vacationDocument.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma ViewController lifecycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupFetchedResultsController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
