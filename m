Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaBTP7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 10:59:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:60484 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaBTP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 10:59:53 -0500
Date: Thu, 20 Feb 2014 16:59:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
cc: Neil Zhang <zhangwm@marvell.com>, Bergmann Arnd <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] irqchip: mmp: avoid use head file in a specific
 arch
In-Reply-To: <CAN1soZxcZ9FuKUeQLYEQxZaDR6CPXOA06bons08abpDDfmnS_w@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402201659460.4468@ionos.tec.linutronix.de>
References: <1386326807-21688-1-git-send-email-zhangwm@marvell.com> <CAN1soZxcZ9FuKUeQLYEQxZaDR6CPXOA06bons08abpDDfmnS_w@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Haojian Zhuang wrote:

> On Fri, Dec 6, 2013 at 6:46 PM, Neil Zhang <zhangwm@marvell.com> wrote:
> > For example, arm64 doesn't have mach/irq.h.
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> > ---
> >  drivers/irqchip/irq-mmp.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/irqchip/irq-mmp.c b/drivers/irqchip/irq-mmp.c
> > index 2cb7cd0..470c5de 100644
> > --- a/drivers/irqchip/irq-mmp.c
> > +++ b/drivers/irqchip/irq-mmp.c
> > @@ -22,7 +22,7 @@
> >  #include <linux/of_irq.h>
> >
> >  #include <asm/exception.h>
> > -#include <asm/mach/irq.h>
> > +#include <asm/hardirq.h>
> >
> >  #include "irqchip.h"
> >
> > --
> > 1.7.9.5
> >
> 
> Hi Thomas,
> 
> Since this patch is pending for a lot of time, could you help to give
> an Ack on this? Then I could push it into arm-soc tree.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
