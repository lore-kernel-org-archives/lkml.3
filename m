Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaIHQjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:39:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61910 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754461AbaIHQji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:39:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+jAlv+d4+maxRP/gJuqKQK
Date: Mon, 8 Sep 2014 09:39:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 08/18] tty: serial: Add 8250-core based omap driver
Message-ID: <20140908163930.GF3238@atomide.com>
References: <1409943773-7874-1-git-send-email-bigeasy@linutronix.de>
 <1409943773-7874-9-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409943773-7874-9-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140905 12:03]:
> 
> It has been only tested as console UART on am335x-evm, dra7-evm and
> beagle bone. I also did some longer raw-transfers to meassure the load.

You may want to also update this with beagleboard xm now too?

Regards,

Tony 
