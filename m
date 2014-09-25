Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaIYMLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:11:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44666 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaIYMLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:11:04 -0400
Date: Thu, 25 Sep 2014 14:10:51 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: efm32: drop selecting NO_DMA
Message-ID: <20140925121051.GM3755@pengutronix.de>
References: <1411585151.19525.29.camel@x220>
 <1411640056.7866.5.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411640056.7866.5.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Thu, Sep 25, 2014 at 12:14:16PM +0200, Paul Bolle wrote:
> On Wed, 2014-09-24 at 20:59 +0200, Paul Bolle wrote:
> > Actually, the only difference I found in the .config file was that after
> > this patch the .config file contained
> >     CONFIG_ARCH_EFM32=y
> > 
> > I have no idea why. Did I botch my test?
Looking at the patch that introduced the NO_DMA select I think I just
copied it from somewhere[1] without questioning it. It seems the symbol
already didn't exist when efm32 hit mainline in
6d85e2b0b6bed6ae7070426d5e43174c593e075c.

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

[1] probably Catalin's 2.6.33 that introduced v7-M support initially.

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
