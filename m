Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3EFWhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:37:14 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52842 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758500Ab3EFWhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:37:09 -0400
Date: Mon, 6 May 2013 16:36:53 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
Message-ID: <20130506223653.GA12089@obsidianresearch.com>
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com>
 <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com>
 <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130506213413.GH5634@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.195
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 12:34:13AM +0300, Aaro Koskinen wrote:
> On Mon, May 06, 2013 at 05:00:56PM -0400, Eduardo Valentin wrote:
> > Introduce HAS_BANDGAP config entry. This config is a
> > boolean value so that arch code can flag is they
> > feature a bandgap device.
> 
> Maybe it could be mentioned that omap-thermal already depend on this?
> At least for a random reviewer it was not immediately clear why this is
> added, especially since there were no users for it in subsequent patches.

I looked (very briefly), and it seemed like omap-thermal is self
contained and doesn't need arch support?

I get the impression it is desired to minimize driver kconfig
dependencies to the minimum required to compile to increase build
testing coverage, so maybe it would be appropriate to drop this
entirely?

Jason
