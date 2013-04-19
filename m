Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab3DSS7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 14:59:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:48378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3DSS7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 14:59:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,510,1363158000"; 
   d="scan'208";a="325041835"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 2/3] mei: fix reading large reposnes
Thread-Topic: [char-misc-next 2/3] mei: fix reading large reposnes
Thread-Index: AQHOPSpDYV6rDO8MGUyIaltfFDk4S5jdqfuAgAA7TJA=
Date: Fri, 19 Apr 2013 18:59:49 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B01F022F4@HASMSX106.ger.corp.intel.com>
References: <1366395415-13031-1-git-send-email-tomas.winkler@intel.com>
 <1366395415-13031-2-git-send-email-tomas.winkler@intel.com>
 <20130419182543.GA30807@kroah.com>
In-Reply-To: <20130419182543.GA30807@kroah.com>
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

> 
> On Fri, Apr 19, 2013 at 09:16:54PM +0300, Tomas Winkler wrote:
> > While writting to device is limitted to max_msg_length advertized in
> > client properites the read can be much longer delivered consequiting
> chunks.
> >
> > We use krealloc to enlarge the buffer when needed.
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Patch 1/3 had some fuzz in interrupt.c, so I fixed that up by hand, but this
> one just fails to apply at all:
> 	checking file drivers/misc/mei/bus.c
> 	checking file drivers/misc/mei/client.c
> 	checking file drivers/misc/mei/client.h
> 	checking file drivers/misc/mei/interrupt.c
> 	Hunk #1 FAILED at 145.
> 	1 out of 1 hunk FAILED
> 	checking file drivers/misc/mei/main.c
> 
> So something is out of sync between us.
> 
> Care to refresh this patch based on my latest tree, and 3/3, and resend
> them?
Grrr,  I sent you one patch less, I've rebased this new spelling fix and missed to count it in.
I'm resending the missing patches.

Tomas 

