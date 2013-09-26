Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3IZRMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:12:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:43671 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3IZRMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:12:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,986,1371106800"; 
   d="scan'208";a="409897855"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 0/3] mei: few more reset recursion fixes
Thread-Topic: [char-misc-next 0/3] mei: few more reset recursion fixes
Thread-Index: AQHOus6oJonULjlPY0aShvZU3jiMgpnYOL1Q
Date: Thu, 26 Sep 2013 17:12:25 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AED2416@HASMSX106.ger.corp.intel.com>
References: <1378117787-11528-1-git-send-email-tomas.winkler@intel.com>
 <20130926153906.GA9267@kroah.com>
In-Reply-To: <20130926153906.GA9267@kroah.com>
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



> > *** BLURB HERE ***
> 
> I think you need to read your emails a bit better :)

Oops.
 
> > Alexander Usyskin (1):
> >   mei: cancel stall timers in mei_reset
> >
> > Tomas Winkler (2):
> >   mei: make me client counters less error prone
> >   mei: bus: stop wait for read during cl state transition
> 
> You tagged all of these for the stable tree, yet didn't ask for them to
> be included in 3.12-final, which is a bit confusing.  If these are
> really issues that people are hitting, don't you want these merged to
> 3.12-final?

Yes it should go to 3.12 as well, I thought this is understood. 
I will refresh myself on the process. 

Thanks
Tomas
 

