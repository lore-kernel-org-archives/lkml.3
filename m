Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaJUJWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:22:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:57980 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaJUJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:47 -0400
Date: Tue, 21 Oct 2014 11:22:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Andersson <bjorn@kryo.se>
cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
In-Reply-To: <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1410211120430.5308@nanos>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Bjorn Andersson wrote:

> On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
> <bjorn.andersson@sonymobile.com> wrote:
> > Introduce the irq_read_line() function to allow device drivers to read
> > the current logical state of an input when the hardware only exposes
> > this through status bits in the interrupt controller.
> >
> > The new function is backed by a new callback function in the irq_chip -
> > irq_read_line() - that can be implemented by irq_chips that owns such
> > status bits.
> >
> > Based on rfc patch from April 2011 by Abhijeet.
> >
> > Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> 
> ping?

Sorry, slipped through the cracks. I was talking about this to Marc
last week and he needs it for yet another reason. He had some thoughts
about the state representation, so I wait for him to comment.

Thanks,

	tglx

