Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3KHIky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:40:54 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:59566 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720Ab3KHIkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:40:52 -0500
Date: Fri, 8 Nov 2013 09:40:35 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Guenter Roeck <linux@roeck-us.net>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3 - V2] Introducing Device Tree Overlays
Message-ID: <20131108084035.GA4074@breakpoint.cc>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
 <20131106190152.GA8662@breakpoint.cc>
 <20131106193041.GA26796@roeck-us.net>
 <20131106203821.GC8662@breakpoint.cc>
 <20131106211754.GA29300@roeck-us.net>
 <20131107192558.GA11453@breakpoint.cc>
 <4F47D5F8-F3C7-45CA-9D88-2D814BDC1BC7@antoniou-consulting.com>
 <20131107204626.GA11746@breakpoint.cc>
 <20131107230052.GC24450@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107230052.GC24450@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.13, Guenter Roeck wrote:
> > I am only saying that this "hot-plug a device at a non hot-plugagle bus at
> > runtime" is not limited to DT but this solution is. X86 + ACPI is not
> > the only limitation. ARM is (forced) going to ACPI as well as far I
> > know. And this solution is limited to DT. This is what I am pointing
> > out.
> > 
> I can't tell about ARM, but I am not entirely sure how ACPI support on ARM
> is going to help us on powerpc.

I'm not saying help. Just if you extend one firmware to solve a problem
you need to do it again on an another firmware.

> > > His use case is not uncommon, believe it or not, and x86 would benefit from
> > > something this flexible.
> > 
> > I *think* a more flexible solution would be something like bus_type which is
> > exposed via configfs. It would be attached behind a certain device/bus where
> > the "physical" hotplug interface is. The user would then be able to read the
> > configuration based on whatever information he has and could then create
> > devices he likes at runtime. This wouldn't depend much on the firmware that is
> > used but would require a little more work I think.
> > 
> Quite frankly, I am interested at a solution that works and solves our problems.
> I am not looking for something that is 100% perfect and may never be delivered.
> 
> Fortunately, the Linux kernel was willing to adopt multiple different file
> systems, and still accepts new ones on a regular basis. If a new file system
> is better, it will start getting used, and old file systems are being phased out
> as fewer people use them. I would hope the same should be possible with DT
> overlays and possible other future solutions for the same problem, and that
> we won't have to wait for the perfect solution from day 1.

don't argue about that. However you have to provide support for those
things, they don't simply phase out. You still have support for reiserfs
but I think a lot (likely not all) of the its users migrated away.

If you guys already talked about this and everyone agreed on this then I
am not standing in your way, never was. I was just curious about the
background for this.

> 
> Guenter

Sebastian
