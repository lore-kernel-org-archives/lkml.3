Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3JYP3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:29:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60893 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab3JYP3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:29:36 -0400
Date: Fri, 25 Oct 2013 20:29:24 +0500
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, kishon@ti.com
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: avoid possible deadlock of
 reg_lock
Message-ID: <20131025152922.GA4263@gmail.com>
References: <1382451159-25183-1-git-send-email-bigeasy@linutronix.de>
 <20131022171359.GC2620@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022171359.GC2620@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 06:13:59PM +0100, Lee Jones wrote:
> On Tue, 22 Oct 2013, Sebastian Andrzej Siewior wrote:
> 
> > Since the addition of continuous sampling mode and shared irq support,
> > the reg_lock lock can be taken with and without interrupts. This patch
> > uses the *_irq* variant which should be used in order to avaoid a deadlock.
> > 
> > Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  drivers/mfd/ti_am335x_tscadc.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> Good catch. Applied, thanks.

Had noticed this and forgot. My bad..

Thanks for catching it.

Zubair
