Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3BZRrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:47:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:50378 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3BZRra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:47:30 -0500
Date: Tue, 26 Feb 2013 18:47:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, horms@verge.net.au
Subject: Re: [PATCH 00/05] irqchip: Renesas INTC External IRQ pin v2 update
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
Message-ID: <alpine.LFD.2.02.1302261846550.22263@ionos>
References: <20130226115834.5630.45471.sendpatchset@w520>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Magnus Damm wrote:

> irqchip: Renesas INTC External IRQ pin v2 update
> 
> [PATCH 01/05] irqchip: intc-irqpin: Whitespace fixes
> [PATCH 02/05] irqchip: intc-irqpin: Cache mapped IRQ
> [PATCH 03/05] irqchip: intc-irqpin: Add force comments
> [PATCH 04/05] irqchip: intc-irqpin: Make use of devm functions
> [PATCH 05/05] irqchip: intc-irqpin: GPL header for platform data
> 
> These patches update the v1 of the INTC External IRQ pin driver
> in various ways based on feedback kindly received from:
> - Simon Horman
> - Kuninori Morimoto
> - Thomas Gleixner
> 
> With the series applied I see the driver as "v2", but
> I prefer to keep these changes as incremental ones instead
> of redoing a single "v2" patch for the driver. The reason
> behind this is that there are on-going back porting efforts
> that are better dealt with using incremental patches.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

For the full series:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> 
>  Depends on:
>  [PATCH] irqchip: Renesas INTC External IRQ pin driver
> 
>  drivers/irqchip/irq-renesas-intc-irqpin.c             |   88 ++++++++---------
>  include/linux/platform_data/irq-renesas-intc-irqpin.h |   19 +++
>  2 files changed, 62 insertions(+), 45 deletions(-)
> 
