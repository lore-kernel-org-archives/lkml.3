Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaEYV6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 17:58:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52462 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaEYV6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 17:58:00 -0400
Date: Sun, 25 May 2014 23:57:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: efm32: add module_exit
Message-ID: <20140525215756.GA18901@pengutronix.de>
References: <1401052385-3786-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401052385-3786-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 11:13:05PM +0200, Vincent Stehlé wrote:
> Add missing specification of efm32_uart_exit as module_exit.
> 
> This fixes the following compilation warning:
> 
>   drivers/tty/serial/efm32-uart.c:840:123: warning: ‘efm32_uart_exit’ defined but not used [-Wunused-function]
This warning doesn't occur in my builds, probably because I have
MODULES=n. I can reproduce it on allmodconfig though.
 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
