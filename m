Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367Ab3JXTQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:16:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3JXTQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:16:08 -0400
Date: Thu, 24 Oct 2013 21:15:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ferruh Yigit <fery@cypress.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        linux-samsung-soc@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Ben Dooks <ben-linux@fluff.org>,
        linux-input@vger.kernel.org, Pau Oliva Fora <pof@eslack.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] input: Remove OOM message after input_allocate_device
Message-ID: <20131024191557.GD3512@pengutronix.de>
References: <cover.1382555436.git.joe@perches.com>
 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
 <20131024182611.GA3512@pengutronix.de>
 <1382640218.22433.71.camel@joe-AO722>
 <20131024184612.GC3512@pengutronix.de>
 <1382640528.22433.75.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382640528.22433.75.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:48:48AM -0700, Joe Perches wrote:
> On Thu, 2013-10-24 at 20:46 +0200, Uwe Kleine-König wrote:
> > On Thu, Oct 24, 2013 at 11:43:38AM -0700, Joe Perches wrote:
> []
> > > Any k.alloc without __GFP_NOWARN does a generic OOM message
> > > and a dump_stack() so there could already be 2 messages anyway.
> > Then mention that in the commit log if you still want this patch?!
> 
> How do you think this commit message should be changed:
> 
> Emitting an OOM message isn't necessary after input_allocate_device
> as there's a generic OOM and a dump_stack already done.
after input_allocate_device and/or k.alloc ...

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
