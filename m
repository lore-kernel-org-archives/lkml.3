Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaCDOmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:42:39 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38443 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168AbaCDOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:42:37 -0500
Date: Tue, 4 Mar 2014 15:41:29 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140304144129.GM16655@lunn.ch>
References: <20140303150215.GI21483@n2100.arm.linux.org.uk>
 <20140303173740.GC16655@lunn.ch>
 <20140303181529.GM21483@n2100.arm.linux.org.uk>
 <20140303222406.GW1872@titan.lakedaemon.net>
 <20140304092616.GH16655@lunn.ch>
 <5315AD6F.1070804@gmail.com>
 <20140304121136.GR21483@n2100.arm.linux.org.uk>
 <20140304135306.GL1872@titan.lakedaemon.net>
 <20140304135452.GK16655@lunn.ch>
 <20140304140135.GS21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304140135.GS21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:01:36PM +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 04, 2014 at 02:54:52PM +0100, Andrew Lunn wrote:
> > > > So we have cpufreq, pm domains and an irq controller.  What's the plan
> > > > for this, who's going to look at sorting this out?
> > > 
> > > Andrew, Sebastian?  I'm currently task-saturated...
> > 
> > I doubt i will be doing anything with it for the remainder of this
> > cycle. I would like to finish converting kirkwood to DT before
> > starting on anything new.
> 
> Okay, can someone send me the cpufreq code then please?

Hi Russell

Take a look at:

https://github.com/lunn/linux.git v3.13-rc2-rafael-next-dove-cpufreq

The cpufreq drivers/framework have been going through quite a bit of
refactoring recently, so maybe some work will be needed on it.

	    Andrew
