Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbaJUGnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 02:43:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51297 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaJUGnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 02:43:02 -0400
Date: Tue, 21 Oct 2014 08:42:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>, Jisheng Zhang <jszhang@marvell.com>,
        Janusz Uzycki <j.uzycki@elproma.com.pl>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Harini Katakam <harinik@xilinx.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.18 Merge window
Message-ID: <20141021064250.GC8316@pengutronix.de>
References: <20141020195319.GA27879@spo001.leaseweb.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141020195319.GA27879@spo001.leaseweb.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wim,

On Mon, Oct 20, 2014 at 09:53:20PM +0200, Wim Van Sebroeck wrote:
> commit 4846e3784585173f48e267b76f968bcb4a12d3b2
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Date:   Tue Sep 9 22:18:31 2014 +0200
> 
>     watchdog: simplify definitions of WATCHDOG_NOWAYOUT(_INIT_STATUS)?
>     
>     Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
I guess it's too late, but somehow my name got mangled here ...

If you consider fixing it (assuming an utf-8 locale):

	git filter-branch --msg-filter 'sed s/=C3=B6/ö/' linus/master..master

Best regards
Uwe

>     Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
