Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3HAO5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 10:57:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:44242 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab3HAO5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 10:57:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,795,1367996400"; 
   d="scan'208";a="340175000"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Pavel Machek <pavel@ucw.cz>
CC: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
        "Joe Lawrence" <joe.lawrence@stratus.com>,
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
Thread-Index: AQHOfae/YJf6t4xSdkSmx+6rM4DMuJlhWxyAgAtunQCAE0KOgIAAgkcA
Date: Thu, 1 Aug 2013 14:57:44 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F92AA6C@ORSMSX102.amr.corp.intel.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <CAErSpo4XrJL48boVNiEb-7Y=52Bx_79hqP909ayLOdm7we_m3Q@mail.gmail.com>
In-Reply-To: <CAErSpo4XrJL48boVNiEb-7Y=52Bx_79hqP909ayLOdm7we_m3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Wednesday, July 31, 2013 4:53 PM
> To: Pavel Machek
> Cc: Greg KH; kernel list; Joe Lawrence; Myron Stowe; Kirsher, Jeffrey T;
> Brandeburg, Jesse; Allan, Bruce W; Wyborny, Carolyn; Skidmore, Donald C;
> Rose, Gregory V; Waskiewicz Jr, Peter P; Duyck, Alexander H; Ronciak, John;
> Dave, Tushar N; e1000-devel@lists.sourceforge.net
> Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
> 
> On Fri, Jul 19, 2013 at 11:46 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> 
> > Just to make sure I understand you correctly: I think you are saying
> > that the NIC has the same problem under Windows.
> 
> Can you confirm or deny that the same problem occurs with Windows?

In our testing here we saw the same problem with Windows.
> 
> > But since the problem also occurs with Windows, it's pretty likely
> > that there's a BIOS update to fix it.  I notice on the X60 support
> > page that there are several versions newer than what you're running.
> 
> Do you have any interest in trying a newer BIOS to see if it's fixed there?  If not, I
> understand; BIOS updates are a hassle at best.
> You're running BIOS 2.14, and it looks like the current BIOS for an
> X60 1709 7HU is 2.19 (from http://support.lenovo.com).
> 
> Carolyn's patch will likely work, at least most of the time, but I think there's a
> small possibility that it could cause a conflict between the BIOS and the OS over
> ASPM control, so I'm not 100% in support of that approach.  A conflict may not
> happen on your machine, and not on my machine, but it may happen
> somewhere, and if it does happen, it's likely to be rare and difficult to debug.
> 
I've proposed a patch for Pavel to test.  I understand your position, but do you have any other proposal?  We have a severe hw problem we are trying alleviate as best we can.  

Pavel, were you also able to try the updated BIOS to see if that resolved the issue without my patch?

Thanks,

Carolyn

