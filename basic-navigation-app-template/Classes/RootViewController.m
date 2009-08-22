#import "RootViewController.h"

#pragma mark import dataSource
#import "RootViewDataSource.h"

# pragma mark import table cells

@implementation RootViewController

			
///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController
		
- (void)loadView {
	[super loadView];
	
	self.tableView = [[[UITableView alloc] initWithFrame:self.view.bounds
												   style:UITableViewStylePlain] autorelease];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
	| UIViewAutoresizingFlexibleHeight;
	self.variableHeightRows = YES;  
	self.title = @"Tutorial Title";
	[self.view addSubview:self.tableView];
}
		
//////////////////////////////////////////////////////////////////////////////////////////////////
// TTTableViewController
			
- (id<TTTableViewDataSource>)createDataSource {
	return [RootViewDataSource rootViewDataSource];
}


@end
			