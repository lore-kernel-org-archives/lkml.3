Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaDYQjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:39:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34841 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDYQjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:39:40 -0400
Message-ID: <535A8FC9.8040707@wwwdotorg.org>
Date: Fri, 25 Apr 2014 10:39:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Marek Vasut <marex@denx.de>, linux-mtd@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency
 for M25P80)
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com> <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 01:21 AM, Brian Norris wrote:
> These defconfigs contain the CONFIG_M25P80 symbol, which is now
> dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> relevant defconfigs.
> 
> At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.

I hadn't realized that the problem this patch solves was already present
in the code, so this patch is simply catching up the defconfigs rather
than part of a series which changed the code to cause the problem.

So, this needs to be applied ASAP.

I think this should be split it up so that each defconfig can go through
the tree that owns it to avoid conflicts. If you repost split up, I can
apply the tegra_defconfig change to the Tegra tree.
