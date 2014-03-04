Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaCDJ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:27:24 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38268 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbaCDJ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:27:22 -0500
Date: Tue, 4 Mar 2014 10:26:16 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] ARM: dove: dt: revert PMU interrupt controller node
Message-ID: <20140304092616.GH16655@lunn.ch>
References: <20140207180836.GE8533@titan.lakedaemon.net>
 <1392667236-19126-1-git-send-email-jason@lakedaemon.net>
 <20140303150215.GI21483@n2100.arm.linux.org.uk>
 <20140303173740.GC16655@lunn.ch>
 <20140303181529.GM21483@n2100.arm.linux.org.uk>
 <20140303222406.GW1872@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303222406.GW1872@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I could have sworn this was discussed with this particular patchset, but
> I'm unable to find the conversation in my archives.  Neither during the
> patch submission process, nor the (long) pull request thread.
> 
> Perhaps it was an irc conversation?  Andrew, Sebastian, can you find a
> link?  iirc, one of the DT maintainers (Mark Rutland?) raised the same
> concern and I thought we answered that sufficiently...

Hi Jason

It was the cpufreq driver which caused the discussion. I looked at it
for a while, and then task swapped onto the kirkwood move into
mach-mvebu.

    Andrew
