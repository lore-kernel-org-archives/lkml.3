Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaGJSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:36:45 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58146 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750768AbaGJSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:36:44 -0400
Date: Thu, 10 Jul 2014 20:36:41 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] irqchip: atmel-aic: Add irq RTC fixups
Message-ID: <20140710203641.2e17de80@bbrezillon>
In-Reply-To: <20140710203249.23dd6444@bbrezillon>
References: <1405016741-2407-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140710203249.23dd6444@bbrezillon>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 20:32:49 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> On Thu, 10 Jul 2014 20:25:38 +0200
> Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:
> 
> > Hello,
> > 
> > This patch series introduce the notion of irq fixups for atmel SoCs.
> > 
> > In most at91 SoCs the first interrupt line is shared by several IPs, and
> > some of these HW blocks might be in an unknown state when booting the
> > Linux kernel.
> > Hence these IPs might generate spurious interrupts if they've not masked
> > their irqs and the shared irq line is requested by another peripheral.
> > 
> > These fixups were previously done in arch/arm/mach-at91/sysirq_mask.c
> > but as we're trying to use standard implementation (IRQCHIP_DECLARE and
> > automatic call of irqchip_init within arch/arm/kernel/irq.c) we need to
> > do those fixups in the irqchip driver.
> 
> This is what I was talking about:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271425.htm
> 
> 

Oops, sorry this is not the appropriate thread: I meant to send this
reply to this series:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271413.html



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
