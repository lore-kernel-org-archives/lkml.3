Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab3HBO7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:59:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:15053 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3HBO7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:59:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="276839930"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Topic: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Index: AQHOfae/YJf6t4xSdkSmx+6rM4DMuJlhWxyAgAtunQCABzyS4IAGpr2AgAEsTUCABMj4wIABCVYAgAB6VSA=
Date: Fri, 2 Aug 2013 14:58:57 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F92BEE4@ORSMSX102.amr.corp.intel.com>
References: <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F921872@ORSMSX102.amr.corp.intel.com>
 <20130728135103.GC5382@amd.pavel.ucw.cz>
 <9BBC4E0CF881AA4299206E2E1412B6264F92AC55@ORSMSX102.amr.corp.intel.com>
 <20130802003952.GA3682@amd.pavel.ucw.cz>
In-Reply-To: <20130802003952.GA3682@amd.pavel.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Thursday, August 01, 2013 5:40 PM
> To: Wyborny, Carolyn
> Cc: Bjorn Helgaas; Greg KH; kernel list; Joe Lawrence; Myron Stowe; Kirsher,
> Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Skidmore, Donald C; Rose, Gregory
> V; Waskiewicz Jr, Peter P; Duyck, Alexander H; Ronciak, John; Dave, Tushar N;
> e1000-devel@lists.sourceforge.net
> Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
> 
> Hi!
> 
> > > > If there's patch, I'll gladly try it :-). Thanks,
> > > >
> > > 								Pavel
> > > Thanks Pavel,
> >
> > Minor fix.  Missed a bracket removal  Please use this  for your testing instead.
> >
> 
> Seems to work here. (I did testing on 3.11-rc, but that should not change things.)
> Latencies are in expected range.
> 
> Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks Pavel,

I'll submit a version of this to our internal queue.

Carolyn
