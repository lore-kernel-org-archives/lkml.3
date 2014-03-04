Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbaCDN4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:56:00 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38408 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757188AbaCDNz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:55:59 -0500
Date: Tue, 4 Mar 2014 14:54:52 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140304135452.GK16655@lunn.ch>
References: <20140207180836.GE8533@titan.lakedaemon.net>
 <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
 <20140303150215.GI21483@n2100.arm.linux.org.uk>
 <20140303173740.GC16655@lunn.ch>
 <20140303181529.GM21483@n2100.arm.linux.org.uk>
 <20140303222406.GW1872@titan.lakedaemon.net>
 <20140304092616.GH16655@lunn.ch>
 <5315AD6F.1070804@gmail.com>
 <20140304121136.GR21483@n2100.arm.linux.org.uk>
 <20140304135306.GL1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304135306.GL1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So we have cpufreq, pm domains and an irq controller.  What's the plan
> > for this, who's going to look at sorting this out?
> 
> Andrew, Sebastian?  I'm currently task-saturated...

I doubt i will be doing anything with it for the remainder of this
cycle. I would like to finish converting kirkwood to DT before
starting on anything new.

	 Andrew
