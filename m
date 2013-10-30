Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3J3VO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:14:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:6764 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3J3VO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:14:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401189435"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Thread-Topic: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Thread-Index: AQHO1P06TyNlQAzZmEa3ng99D0wzFJoM1X5ggABGawCAAJ7BAA==
Date: Wed, 30 Oct 2013 21:14:44 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AEFE97C@HASMSX106.ger.corp.intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
 <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
 <20131029231841.GA30410@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AEFB8F5@HASMSX106.ger.corp.intel.com>
 <20131030132658.GC30447@kroah.com>
In-Reply-To: <20131030132658.GC30447@kroah.com>
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



> On Wed, Oct 30, 2013 at 07:16:07AM +0000, Winkler, Tomas wrote:
> > >
> > > On Mon, Oct 21, 2013 at 10:05:36PM +0300, Tomas Winkler wrote:
> > > > make static analyzer happy
> > >
> > > That's a stupid analyzer.
> > >
> > > Sorry, this case can never be true, so don't check for it.  Fix your
> > > analyzer.
> > >
> > > > and validate dev argument before dereferencing
> > >
> > > Again, no need to do so, it's always set properly.
> > >
> > > sorry, I can't take this.
> >
> > Fair enough, I didn't like that patch myself now I have other confirmation that
> this is stupid.
> 
> This is about the 10th time I have gotten patches that are somehow being
> _forced_ by Intel developers to submit, and require me to say they are
> stupid and wrong and push back on.
> 
> Someone needs to go stop that Intel code analyzer and push back on them
> directly, don't rely on me being the one to do this, it only makes me
> grumpy and mad when you all make me do your job on this :(
>
These tools and BKMs have a lot of false alarms, but sometimes they hit the nail.
It was just my personal bad call, to send this patch out.
But I really don't know about others, Intel is a big company. 

Thanks
Tomas


