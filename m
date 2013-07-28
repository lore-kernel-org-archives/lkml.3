Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3G1Isa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 04:48:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:6759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab3G1Is2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 04:48:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,763,1367996400"; 
   d="scan'208";a="372417185"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ovsyanikov, Natalia" <natalia.ovsyanikov@intel.com>
Subject: RE: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Topic: [char-misc-next 2/3] mei: adding sysfs fw_status attribute
Thread-Index: AQHOiIb0dT8QWA0joUSnTutOsRQJK5l0Aa0g///P94CAAE2lEP//9n6AgAW3aVA=
Date: Sun, 28 Jul 2013 08:48:24 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AE76B1B@HASMSX106.ger.corp.intel.com>
References: <1374680517-30894-1-git-send-email-tomas.winkler@intel.com>
 <1374680517-30894-3-git-send-email-tomas.winkler@intel.com>
 <20130724160008.GA17083@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE738C0@HASMSX106.ger.corp.intel.com>
 <20130724162605.GA9700@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AE73993@HASMSX106.ger.corp.intel.com>
 <20130724202957.GA14913@kroah.com>
In-Reply-To: <20130724202957.GA14913@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jul 24, 2013 at 06:04:33PM +0000, Winkler, Tomas wrote:
> >
> >
> > > >
> > > > Just to make sure, is this what you're suggesting ?
> > > >
> > > > device->groups = mei_attr_groups
> > > > mei_misc_device.parent = device;
> > > > ret = misc_register(&mei_misc_device);
> > >
> > > Yes, that should work.  If not, please let me know, the code
> > > underwent some changes in 3.11-rc2.
> >
> > I don' t see the file being created.
> > Not sure if the  misc_register setup the parent sysfs as well.
> 
> Oops, wait, the parent is already registered, that's not going to work, you
> want to create the files for the device itself that you are creating, so set the -
> >groups field for that device.
> 
> sorry about that.

So is this okay to go as  is?
Thanks
Tomas

