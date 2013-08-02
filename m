Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3HBAjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 20:39:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33727 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3HBAjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 20:39:54 -0400
Date: Fri, 2 Aug 2013 02:39:52 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <greg@kroah.com>,
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
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130802003952.GA3682@amd.pavel.ucw.cz>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6264F92AC55@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > If there's patch, I'll gladly try it :-). Thanks,
> > >
> > 								Pavel
> > Thanks Pavel,
> 
> Minor fix.  Missed a bracket removal  Please use this  for your testing instead.
> 

Seems to work here. (I did testing on 3.11-rc, but that should not
change things.) Latencies are in expected range.

Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
