Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbaIIAl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 20:41:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55395 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaIIAly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 20:41:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NaPfzduWKLaQIFzb0ORYK
Date: Mon, 8 Sep 2014 17:41:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: Re: [PATCH 03/18] tty: serial: 8250_core: allow to set ->throttle /
 ->unthrottle callbacks
Message-ID: <20140909004146.GF10785@atomide.com>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <1409943773-7874-4-git-send-email-bigeasy@linutronix.de>
 <20140908233329.GA32144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908233329.GA32144@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> [140908 16:33]:
> On Fri, Sep 05, 2014 at 09:02:38PM +0200, Sebastian Andrzej Siewior wrote:
> > The OMAP UART provides support for HW assisted flow control. What is
> > missing is the support to throttle / unthrottle callbacks which are used
> > by the omap-serial driver at the moment.
> > This patch adds the callbacks. It should be safe to add them since they
> > are only invoked from the serial_core (uart_throttle()) if the feature
> > flags are set.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> Due to other recent changes, this patch fails to apply :(
> 
> I've applied your first two, can you respin the rest and resend as a new
> series?

It seems that we've reached pretty much omap-serial compability and
the remaining bugs are either already there with omap-serial or are
SoC specific and/or DMA related. So Sebastian, please feel also free
to add this when reposting:

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>
