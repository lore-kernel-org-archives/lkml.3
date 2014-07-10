Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaGJSeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:34:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58121 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbaGJSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:34:23 -0400
Date: Thu, 10 Jul 2014 20:34:20 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/7] ARM: at91: move aic driver to drivers/irqchips
Message-ID: <20140710203420.64ab24df@bbrezillon>
In-Reply-To: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405012462-766-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014 19:14:15 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Hello,
> 
> This series moves the AIC driver to the irqchip directory and make use of
> the generic chip framework whenever possible.
> 
> This driver only support DT boards (all legacy board files should be soon
> replaced by their DT versions).
> 
> Since the last version AIC and AIC5 code have been split and common
> functions have been moved to irq-atmel-aic-common.c.
> I know there is not much code in this file and it could have been
> duplicated in AIC and AIC5 drivers, but I'm planning to add more common
> stuff soon (AIC irq fixups previously done in
> arch/arm/mach-at91/sysirq_mask.c).

This is what I was talking about:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/271425.html

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
