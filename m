Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaCDOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 09:01:49 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37481 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757141AbaCDOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 09:01:48 -0500
Date: Tue, 4 Mar 2014 14:01:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140304140135.GS21483@n2100.arm.linux.org.uk>
References: <1392667236-19126-1-git-send-email-jason@lakedaemon.net> <20140303150215.GI21483@n2100.arm.linux.org.uk> <20140303173740.GC16655@lunn.ch> <20140303181529.GM21483@n2100.arm.linux.org.uk> <20140303222406.GW1872@titan.lakedaemon.net> <20140304092616.GH16655@lunn.ch> <5315AD6F.1070804@gmail.com> <20140304121136.GR21483@n2100.arm.linux.org.uk> <20140304135306.GL1872@titan.lakedaemon.net> <20140304135452.GK16655@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304135452.GK16655@lunn.ch>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 02:54:52PM +0100, Andrew Lunn wrote:
> > > So we have cpufreq, pm domains and an irq controller.  What's the plan
> > > for this, who's going to look at sorting this out?
> > 
> > Andrew, Sebastian?  I'm currently task-saturated...
> 
> I doubt i will be doing anything with it for the remainder of this
> cycle. I would like to finish converting kirkwood to DT before
> starting on anything new.

Okay, can someone send me the cpufreq code then please?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
