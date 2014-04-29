Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbaD2Szt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:55:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:44378 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090AbaD2Szs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:55:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/v6fOcd3C41v5xd2NMFCW6SmMHPcIfJ54=
X-DKIM: OpenDKIM Filter v2.0.1 titan 785235674CF
Date: Tue, 29 Apr 2014 14:55:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 1/5] ARM: defconfigs: add MTD_SPI_NOR (new dependency
 for M25P80)
Message-ID: <20140429185527.GP28159@titan.lakedaemon.net>
References: <1397719309-2022-1-git-send-email-computersforpeace@gmail.com>
 <1397719309-2022-2-git-send-email-computersforpeace@gmail.com>
 <535A8FC9.8040707@wwwdotorg.org>
 <20140429172227.GB11657@arch.cereza>
 <20140429174849.GO28159@titan.lakedaemon.net>
 <20140429182815.GA28069@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429182815.GA28069@arch.cereza>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 03:28:15PM -0300, Ezequiel Garcia wrote:
> On Apr 29, Jason Cooper wrote:
> > On Tue, Apr 29, 2014 at 02:22:27PM -0300, Ezequiel Garcia wrote:
> > > On Apr 25, Stephen Warren wrote:
> > > > On 04/17/2014 01:21 AM, Brian Norris wrote:
> > > > > These defconfigs contain the CONFIG_M25P80 symbol, which is now
> > > > > dependent on the MTD_SPI_NOR symbol. Add CONFIG_MTD_SPI_NOR to the
> > > > > relevant defconfigs.
> > > > > 
> > > > > At the same time, drop the now-nonexistent CONFIG_MTD_CHAR symbol.
> > 
> > Excuse my ignorance of the history of this bug, but shouldn't this be
> > solved in the Kconfig logic?  Since when do we solve config symbol
> > dependency bugs in the defconfigs?
> > 
> 
> Long story short: it was decided that select'ing this new symbol was not
> appropriate. Instead, it must be explicitly selected by the user, hence
> the defconfig fix.
> 
> The full story: https://lkml.org/lkml/2014/4/17/45

ahhh, it already depend's on MTD_SPI_NOR in Kconfig

  http://git.infradead.org/l2-mtd.git/blobdiff/254592db612aeb55d80399a04995b68f7da48c99..e43b20619bdb6c851dd7b49cbd15e52875a785d4:/drivers/mtd/devices/Kconfig

ok, now it makes sense.

Acked-by: Jason Cooper <jason@lakedaemon.net>

thx,

Jason.
