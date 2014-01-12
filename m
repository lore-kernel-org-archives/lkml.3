Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaALJAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:00:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:19980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaALJAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:00:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,646,1384329600"; 
   d="scan'208";a="465363104"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Usyskin, Alexander" <alexander.usyskin@intel.com>
Subject: RE: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Thread-Topic: [char-misc 1/4] mei: do not run reset flow from the interrupt
 thread
Thread-Index: AQHPDMirDYT8E/RffEyxtLkF2amaZZp/unswgABW+QCAALrBsA==
Date: Sun, 12 Jan 2014 09:00:16 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AF41572@HASMSX106.ger.corp.intel.com>
References: <1389205164-13553-1-git-send-email-tomas.winkler@intel.com>
 <1389205164-13553-2-git-send-email-tomas.winkler@intel.com>
 <20140108232410.GA11300@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF40FBF@HASMSX106.ger.corp.intel.com>
 <20140111233848.GB6819@kroah.com>
In-Reply-To: <20140111233848.GB6819@kroah.com>
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



> On Sat, Jan 11, 2014 at 10:46:14PM +0000, Winkler, Tomas wrote:
> >
> >
> > >
> > > This is a _really_ big patch for a stable kernel tree.  Are you sure
> > > it's needed there?  Please go read Documentation/stable_kernel_rules.txt
> > > again.
> >
> > I understand it's big though currently I do not have significantly
> > simpler fix for the issue, all 4 patches are needed to make the reset
> > issue  go away.
> 
> What is the "reset issue"?  Who is it affecting?  What is the problem?

Reported here: 

https://lkml.org/lkml/2013/12/22/102
https://lkml.org/lkml/2013/11/1/190
https://bugzilla.novell.com/show_bug.cgi?id=821619

maybe few more other places, I've already tried to address the issue but it looks I didn't hit the nail till now.. 

> Is there a work-around without this patchset?

Disabling timer_work has same effect 

https://lkml.org/lkml/2013/11/7/179


but  I haven't checked fi it does have another side effects mostly in AMTHI. 

> 
> As it is, I can't take something this big for the stable tree, sorry.
> 

Understood, I will try to find smaller fix to target stable.

Thanks
Tomas
