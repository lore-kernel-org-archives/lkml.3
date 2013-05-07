Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab3EGAhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:37:04 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:40800 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab3EGAhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:37:02 -0400
Date: Mon, 6 May 2013 18:36:51 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, tony@atomide.com,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
Message-ID: <20130507003651.GA26035@obsidianresearch.com>
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com>
 <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com>
 <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
 <20130506223653.GA12089@obsidianresearch.com>
 <51884971.9050508@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51884971.9050508@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 08:23:13PM -0400, Eduardo Valentin wrote:

> > I get the impression it is desired to minimize driver kconfig
> > dependencies to the minimum required to compile to increase build
> > testing coverage, so maybe it would be appropriate to drop this
> > entirely?

> Well, it is also desired to compile things to the correct target
> right?

There is some of that too..

But broadly the direction seems that drivers should have minimal
dependencies so, eg, the thermal maintainer compiling for x86 should
be able to compile test/static analyze your driver..

> Thats the idea behind this config option. It follows the same design as
> CONFIG_ARCH_HAS_CPUFREQ, for instance.

That is entirely contained inside arch/arm and doesn't involve
drivers.

Jason
