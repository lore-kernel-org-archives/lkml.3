Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaKSKKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:10:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54147 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKSKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:09:58 -0500
Date: Wed, 19 Nov 2014 11:09:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] gpiolib: use const parameters when possible
Message-ID: <20141119100954.GV27002@pengutronix.de>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
 <1360738983-22436-3-git-send-email-gnurou@gmail.com>
 <20141117090915.GE27002@pengutronix.de>
 <CAAVeFuKzP0ADix8TxC31ohb3ZmnEVmNcO5kgzhZ3DcwAhTq=-Q@mail.gmail.com>
 <20141119084432.GT27002@pengutronix.de>
 <CAAVeFuLtQoxt_D_TaRQc49Sh0FZTg=q4y5QorZ7OUK+qPE0CbQ@mail.gmail.com>
 <20141119090222.GU27002@pengutronix.de>
 <CAAVeFu+zc6tiM-SvwQ3mQmkMNdY+1+Ysi0F2eThyCjziKVwpOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVeFu+zc6tiM-SvwQ3mQmkMNdY+1+Ysi0F2eThyCjziKVwpOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alexandre,

On Wed, Nov 19, 2014 at 06:07:50PM +0900, Alexandre Courbot wrote:
>  On Wed, Nov 19, 2014 at 6:02 PM, Uwe Kleine-König
> <u.kleine-koenig@pengutronix.de> wrote:
> > I'd make gpiod_get_direction static and only use it to fill in
> > /sys/kernel/debug/gpio.
> 
> That's very tempting. I see only atmel_serial.c using this function,
> and there is no gpio_get_direction() declared anywhere so no user of
> this either. I'm not sure what I was thinking when I decided to export
> it?
In next there is also drivers/tty/serial/mxs-auart.c.
 
Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
