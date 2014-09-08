Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbaIHQl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:41:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:49573 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaIHQly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:41:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dW9WeKfxn92davzregMf7
Date: Mon, 8 Sep 2014 09:41:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 11/18] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
Message-ID: <20140908164147.GG3238@atomide.com>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <1409943773-7874-12-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409943773-7874-12-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140905 12:28]:
> This problem has not been seen on DRA7 or beaglebone (OMAP3). I am not
> sure if this is UART-IP core specific or DMA engine.

Maybe check this comment for future reference too because
beaglebone and bealeboard do different things for PM.. Do
you mean Beaglebone or beagleboard? Or both?

Regards,

Tony
