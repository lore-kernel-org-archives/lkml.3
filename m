Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab3KUV1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 16:27:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:41617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KUV1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 16:27:20 -0500
Date: Thu, 21 Nov 2013 22:27:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] irqchip: versatile FPGA: support cascaded interrupts
 from DT
In-Reply-To: <CACRpkda6XcEA3xri116q=U26Cm3BeMWv4Us40FCyxGj3o+DAFw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311212226280.30673@ionos.tec.linutronix.de>
References: <1380893106-7550-1-git-send-email-linus.walleij@linaro.org> <CACRpkda6XcEA3xri116q=U26Cm3BeMWv4Us40FCyxGj3o+DAFw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus

On Thu, 21 Nov 2013, Linus Walleij wrote:

> On Fri, Oct 4, 2013 at 3:25 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> 
> > The Versatile FPGA interrupt controller supports cascading interrupts,
> > i.e. that its output is connected to the input of another interrupt
> > controller. This makes it possible to pass a parent interrupt from
> > the device tree and print it in the boot log if applicable.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> > TGLX: I can take this through ARM SoC if you're happy with it
> > and prefer it that way, but it merges just as fine as it is on
> > the IRQ tree.
> 
> Ping on this!

by all means, I can't find the original patch anywhere in my mail
folders. Can you bounce it to me please?

Thanks,

	tglx
