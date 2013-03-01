Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3CAPDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:03:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab3CAPDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:03:37 -0500
Date: Fri, 1 Mar 2013 16:03:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, kuninori.morimoto.gx@renesas.com,
        linux-sh@vger.kernel.org, benh@kernel.crashing.org,
        grant.likely@secretlab.ca, horms@verge.net.au, tglx@linutronix.de
Subject: Re: [PATCH 00/05] irqchip: Renesas INTC External IRQ pin v2 update
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
Message-ID: <Pine.LNX.4.64.1303011603060.18776@axis700.grange>
References: <20130226115834.5630.45471.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:UFHg6aO1ZhS2nISjJ0ZPT1eEJAGUk679daQ0ysA5tKt
 9EzQvISzEs3YktfJwrF5P+7k1lRP9pLiaDpmJAItvoZArY2cuz
 r8ugqkNURJWUPp4YhsOLIYvDXzeBtPDQfpJoFuTSe5nnTnUYhR
 rv8/cFK2yL0rW4KNAfChEtiIqjbWVqRUczQre79TJiif1Skhu+
 P5s6HOZ5GRqXdskDOXi0EUYLcr8CfHchV/14PtvAd6X4OB1E2u
 Yqvn2VzyNK5t1jAnb6Gv9O2xaFC375eOaZcQa5hgllx6/G4Urb
 12C8ZLl9I3qyF1ApOuRArH+kN4c1VP/n+oif6P7o9EpaJlu0IH
 j0/q3SeR0gu+wkcfbBiq7TkHBF7fVNmI5vPQ+bNFQpfhU6MXF3
 6rCS+wNXUXhDQ==
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

tested on kzm9g in topic/all+next branch of

https://git.kernel.org/cgit/linux/kernel/git/horms/renesas.git/

Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
> 
>  Depends on:
>  [PATCH] irqchip: Renesas INTC External IRQ pin driver
> 
>  drivers/irqchip/irq-renesas-intc-irqpin.c             |   88 ++++++++---------
>  include/linux/platform_data/irq-renesas-intc-irqpin.h |   19 +++
>  2 files changed, 62 insertions(+), 45 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
