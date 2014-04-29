Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbaD2S2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:28:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:42448 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932491AbaD2S2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:28:47 -0400
Date: Tue, 29 Apr 2014 15:28:15 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency for
 M25P80)
Message-ID: <20140429182815.GA28069@arch.cereza>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429172227.GB11657@arch.cereza>
 <20140429174849.GO28159@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140429174849.GO28159@titan.lakedaemon.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 29, Jason Cooper wrote:
> On Tue, Apr 29, 2014 at 02:22:27PM -0300, Ezequiel Garcia wrote:
> > On Apr 25, Stephen Warren wrote:
> > > On 04/17/2014 01:21 AM, Brian Norris wrote:
> > > > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> > > > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> > > > relevant defconfigs.
> > > > 
> > > > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> 
> Excuse my ignorance of the history of this bug, but shouldn't this be
> solved in the Kconfig logic?  Since when do we solve config symbol
> dependency bugs in the defconfigs?
> 

Long story short: it was decided that select'ing this new symbol was not
appropriate. Instead, it must be explicitly selected by the user, hence
the defconfig fix.

The full story: https://lkml.org/lkml/2014/4/17/45

And in particular: https://lkml.org/lkml/2014/4/21/425
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
