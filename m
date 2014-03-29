Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaC2UiR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 16:38:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:29045 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaC2Uhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 16:37:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,757,1389772800"; 
   d="scan'208";a="509663676"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Topic: 3.0 -> 3.10 regression? poweroff instead of reboot?
Thread-Index: AQHPS0iuvgiDnehMNEeghRTCX5Z79Jr4hhDw
Date: Sat, 29 Mar 2014 20:37:35 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B1AFAD3D0@HASMSX106.ger.corp.intel.com>
References: <20140310145530.GA27230@pcnci.linuxbox.cz>
 <20140329121550.GA5878@nik-comp.linuxbox.cz>
In-Reply-To: <20140329121550.GA5878@nik-comp.linuxbox.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (CC Tomas Winkler)
> 
> So finally I got some time to look deeper into this, and the problem
> might not be regression after all.. It is caused by mei_me module,
> blacklisting it "fixes it" for me.
> 
> So for me it's kinda of solution, although I guess MEI related people
> might be interested in it..
> 
> If I could be of any help, please let me know - at least I've got hardware
> on which I can reproduce the problem..
> 
> BR
> 
> nik
> 
> 
> On Mon, Mar 10, 2014 at 03:55:30PM +0100, Nikola Ciprich wrote:
> > Hi,
> >
> > after installing new server, we've noticed weird behaviour: when box is
> > about to reboot, it powers off instead. This was with 3.10.33, downgrading
> > to 3.0.101 seems to fix this problem. I didn't have time to play with it today
> > and box had to be shipped today, so it'll take few days before I'll have chance
> > for further research, but I wanted to ask whether somebody has met similar
> > problem and what I should check first?
> >
> > The system is x86_64 centos 6, HW is supermicro x9sci-ln4f.
> >
> > Any help appreciated
> >
> > When I have chance to put my hands on this box again, I'll try
> > latest kernel and I can also do bisect, if needed.
> >
> > BR
> >
> > nik

If this is a server platform can you please try this patch https://lkml.org/lkml/2014/3/25/396

Thanks
Tomas

