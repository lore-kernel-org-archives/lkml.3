Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab3CAJlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:41:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:43668 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab3CAJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:41:34 -0500
Date: Fri, 1 Mar 2013 18:41:30 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        tglx@linutronix.de
Subject: Re: [PATCH] irqchip: Renesas IRQC driver
Message-ID: <20130301094125.GA27938@verge.net.au>
References: <20130227081501.30706.60471.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130227081501.30706.60471.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 05:15:01PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch adds a driver for external IRQ pins connected
> to the IRQC hardware block on recent SoCs from Renesas.
> 
> The IRQC hardware block is used together with more
> recent ARM based SoCs using the GIC. As usual the GIC
> requires external IRQ trigger setup somewhere else
> which in this particular case happens to be IRQC.
> 
> This driver implements the glue code needed to configure
> IRQ trigger and also handle mask/unmask and demux of
> external IRQ pins hooked up from the IRQC to the GIC.
> 
> Tested on r8a73a4 but is designed to work with a wide
> range of SoCs. The driver requires one GIC SPI per
> external IRQ pin to operate.  Each driver instance
> will handle up to 32 external IRQ pins.
> 
> The SoCs using this driver are currently mainly used
> together with regular platform devices so this driver
> allows configuration via platform data to support things
> like static interrupt base address. DT support will
> be added incrementally in the not so distant future.

Hi Magnus, Hi all,

I do not expect this code to go through the renesas tree.  However, in
order to provide a basis for work on renesas SoCs I have added this patch
to the topic/intc-external-irq topic branch in the reneas tree on
kernel.org and merged it into topic/all+next.

In other words, I am not picking this series up to merge it or add it to
linux-next, rather I am storing it for reference.

