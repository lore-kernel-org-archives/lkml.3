Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbaKZIU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:20:57 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41369 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781AbaKZIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:20:56 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Ge//FvsCBkMAiGuxvq2Bmx6PZ8WlY8xw=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6CF256243B9
Date: Wed, 26 Nov 2014 03:20:46 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] irqchip: dw-apb-ictl:
 IRQ_GC_MASK_CACHE_PER_TYPE and PM support
Message-ID: <20141126082046.GF22670@titan.lakedaemon.net>
References: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415773374-4629-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:22:51PM +0800, Jisheng Zhang wrote:
> These patches try to improve dw-apb-ictl irqchip driver a bit.
> 
> The first patch improves the performance a bit -- use the relaxed version
> 
> The two dw-apb-ictl's irq_chip_type instances have separate mask registers, so the second patch enables IRQ_GC_MASK_CACHE_PER_TYPE.
> 
> The last patch adds suspend/resume support to the driver.
> 
> Tested on Marvell BG2Q-DMP board.
> 
> Changes in v2:
>   - Add Sebastian's Acks
>   - Update the first commit as Sebastian and Thomas suggested
>   - Add into commit log summary of the discussion why relaxed variants can be used
> 
> Jisheng Zhang (3):
>   irqchip: dw-apb-ictl: always use use {readl|writel}_relaxed
>   irqchip: dw-apb-ictl: enable IRQ_GC_MASK_CACHE_PER_TYPE
>   irqchip: dw-apb-ictl: add PM support
> 
>  drivers/irqchip/irq-dw-apb-ictl.c | 32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)

Whole series applied to irqchip/core

thx,

Jason.
