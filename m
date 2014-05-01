Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaEAGHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:07:45 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57828 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEAGHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:07:44 -0400
Date: Wed, 30 Apr 2014 23:07:39 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        linux-mtd@lists.infradead.org, Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency for
 M25P80)
Message-ID: <20140501060739.GH2497@norris-Latitude-E6410>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429190603.GB9418@norris-Latitude-E6410>
 <536000BA.4000101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536000BA.4000101@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 01:42:50PM -0600, Stephen Warren wrote:
> I guess you could also just see if arm-soc (arm@kernel.org) will take
> this patch, and deal with any merge conflicts that arise when they merge
> all the sub-arch defconfig changes. I CC'd them to find out if they
> think that's a better idea.

I'm preparing a split patch series and should send v2 shortly. A few of
the unaccounted platforms + the multi-platform are lumped together for
direct inclusion in arm-soc (?).

What is this arm@kernel.org you speak of? My Google-fu doesn't turn up a
separate arm-soc email / mailing list, and it's not in MAINTAINERS.

Brian
