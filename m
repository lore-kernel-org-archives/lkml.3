Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbaGCSzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:55:53 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:58741 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaGCSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:55:51 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 14:55:51 EDT
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 3 Jul 2014 14:48:08 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140703184808.GD17769@csclub.uwaterloo.ca>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 06:00:09PM +0200, Sebastian Andrzej Siewior wrote:
> This patch provides a 8250-core based UART driver for the internal OMAP
> UART. The longterm goal is to provide the same functionality as the
> current OMAP uart driver and hopefully DMA support which could borrowed
> from the 8250-core.

This sounds interesting.  We are currently finding the omap serial driver
awefully slow at handling serial traffic with ti's 3.12.y kernel branch,
while the 3.8.y was seemingly a bit better (on the dra7xx eval board).
Haven't had time to really investigate that yet though.

> The whole PM-Runtime part is currently missing.
> It has been only tested as console UART.
> The tty name is ttyS based instead of ttyO. How big is the pain here,
> what could be the easiest way to provide compatibility?

I would certainly love to see ttyS instead of ttyO.  But of course I am
working on a new system that isn't released yet so changing things is
a complete non issue for me. :)

I should give this driver a try and see how it compares so far.

-- 
Len Sorensen
