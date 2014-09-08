Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaIHXdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:33:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaIHXda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:33:30 -0400
Date: Mon, 8 Sep 2014 16:33:29 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com
Subject: Re: [PATCH 03/18] tty: serial: 8250_core: allow to set ->throttle /
 ->unthrottle callbacks
Message-ID: <20140908233329.GA32144@kroah.com>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <1409943773-7874-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409943773-7874-4-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 09:02:38PM +0200, Sebastian Andrzej Siewior wrote:
> The OMAP UART provides support for HW assisted flow control. What is
> missing is the support to throttle / unthrottle callbacks which are used
> by the omap-serial driver at the moment.
> This patch adds the callbacks. It should be safe to add them since they
> are only invoked from the serial_core (uart_throttle()) if the feature
> flags are set.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Due to other recent changes, this patch fails to apply :(

I've applied your first two, can you respin the rest and resend as a new
series?

thanks,

greg k-h
