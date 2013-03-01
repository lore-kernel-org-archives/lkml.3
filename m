Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab3CAJlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:41:46 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:43682 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3CAJln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:41:43 -0500
Date: Fri, 1 Mar 2013 18:41:41 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, tglx@linutronix.de
Subject: Re: [PATCH 00/05] irqchip: Renesas INTC External IRQ pin v2 update
Message-ID: <20130301094140.GB27938@verge.net.au>
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

Hi Magnus, Hi all,

I do not expect this code to go through the renesas tree.  However, in
order to provide a basis for work on renesas SoCs I have added this series
to the topic/intc-external-irq topic branch in the reneas tree on
kernel.org and merged it into topic/all+next.

In other words, I am not picking this series up to merge it or add it to
linux-next, rather I am storing it for reference.
