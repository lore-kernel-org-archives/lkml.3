Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaJBQnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:43:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33353 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaJBQnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:43:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/bZc7BPS01Q2CXE40LUCpD
Date: Thu, 2 Oct 2014 09:43:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/13 v10] omap 8250 based UART + DMA
Message-ID: <20141002164339.GL3122@atomide.com>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140929 11:07]:
> The queue is getting smaller. The highlights of v9…v10
> - the DMA stall Frans Klaver reported which popped up in yocto is gone. It
>   also seems that the "ack the err-irq even if nothing happened" in EDMA
>   can be dropped.
> - the RX- and TX-DMA callbacks are now OMAP-only and no "bugs" flags are
>   introduced into the generic DMA code. This also means that there is
>   custom IRQ routine in case of DMA.

Looks good to me. For the patches that do not yet have my acks, please
feel free to add:

Reviewed-by: Tony Lindgren <tony@atomide.com>
Tested-by: Tony Lindgren <tony@atomide.com>

It's probably best that I queue the .dts changes separately though
to avoid pointless merge conflicts.

Regards,

Tony
