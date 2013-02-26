Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3BZMO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:14:29 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:57654 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3BZMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:14:28 -0500
Date: Tue, 26 Feb 2013 21:14:26 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, tglx@linutronix.de
Subject: Re: [PATCH 00/05] irqchip: Renesas INTC External IRQ pin v2 update
Message-ID: <20130226121425.GB17704@verge.net.au>
References: <20130226115834.5630.45471.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 08:58:34PM +0900, Magnus Damm wrote:
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

I have added these to the topic/intc-external-irq branch of the renesas
tree, although at this stage I anticipate that the code will be merged
through a different tree.
