Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbaD2RXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:23:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758372AbaD2RW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:22:59 -0400
Date: Tue, 29 Apr 2014 14:22:27 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@freescale.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency for
 M25P80)
Message-ID: <20140429172227.GB11657@arch.cereza>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535A8FC9.8040707@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 25, Stephen Warren wrote:
> On 04/17/2014 01:21 AM, Brian Norris wrote:
> > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> > relevant defconfigs.
> > 
> > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> I hadn't realized that the problem this patch solves was already present
> in the code, so this patch is simply catching up the defconfigs rather
> than part of a series which changed the code to cause the problem.
> 
> So, this needs to be applied ASAP.
> 

What's the status of this?

> I think this should be split it up so that each defconfig can go through
> the tree that owns it to avoid conflicts. If you repost split up, I can
> apply the tegra_defconfig change to the Tegra tree.
> 

Probably the same for mvebu (Ccing Jason).
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
