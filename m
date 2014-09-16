Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaIPQtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:49:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56168 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaIPQtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:49:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qeYf7Ooat9OCzFK9DTg5X
Date: Tue, 16 Sep 2014 09:48:59 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
Message-ID: <20140916164858.GA1580@atomide.com>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
 <20140912224324.GK18849@atomide.com>
 <5416D2A0.5020407@linutronix.de>
 <541833C0.5020106@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541833C0.5020106@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140916 05:58]:
> On 09/15/2014 01:50 PM, Sebastian Andrzej Siewior wrote:
> > I changed the restore function the fix the am335x-evm + less "freeze".
> > And now we have this. So let me search…
> 
> IER was 0 by accident. It fixed in TX path.
> I pushed uart_v10_pre1 which should have it fixed aport from other
> things…

Just verified that works for my off-idle test case thanks.

> I am going to address the review comments, to split the DMA callbacks
> as requested and if nobody comes up with something fancy we will have a
> v10 :)

OK

Regards,

Tony
