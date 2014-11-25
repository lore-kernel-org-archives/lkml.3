Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbaKYIB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:01:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39941 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaKYIB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:01:26 -0500
Date: Tue, 25 Nov 2014 09:01:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] gpio: remove const modifier from gpiod_get_direction()
Message-ID: <20141125080122.GY4431@pengutronix.de>
References: <1416900045-2304-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416900045-2304-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

just some minor nitpicking on the commit log:

On Tue, Nov 25, 2014 at 04:20:45PM +0900, Alexandre Courbot wrote:
> Although gpiod_get_direction() can be considered side-effect free for
> consumers, its internals involve setting or clearing bits in the
> affected GPIO descriptor, for which we need to force-cast the const
> descriptor parameter. This could lead to incorrect behavior is the
s/ is/ if/, and I think s/parameter/variable to non-const/

> compiler decide to optimize here, so remove this const parameter. The
s/decide/decides/; s/parameter/attribute/

> intent is to make gpiod_get_direction() private anyway, so it does not
> really matter.
> 
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
