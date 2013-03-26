Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab3CZNDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:03:06 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:60147 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759625Ab3CZNDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:03:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver V3
Date: Tue, 26 Mar 2013 14:03:49 +0100
Message-ID: <2667057.bEM8NUnrg3@avalon>
User-Agent: KMail/4.10 (Linux/3.7.10-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <20130326002301.10878.32801.sendpatchset@w520>
References: <20130326002301.10878.32801.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thanks for the patch.

On Tuesday 26 March 2013 09:23:01 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch is V3 of a GPIO driver for the R-Car series of
> SoCs from Renesas. This driver is designed to be reusable
> between multiple SoCs that share the same basic building block,
> but so far it has only been used on R-Car H1 (r8a7779).
> 
> Each driver instance handles 32 GPIOs with individually
> maskable IRQs. The driver operates on a single I/O memory
> range and the 32 GPIOs are hooked up a single interrupt.
> 
> In the case of R-Car H1 either external IRQ pins or GPIOs
> with interrupts can be used for on-board interupts. For
> external IRQs 4 pins are supported, and in the case of GPIO
> there are 202 GPIOS as 202 interrupts hooked up via 6 driver
> instances and to the GIC and the Cortex-A9 Quad.
> 
> At this point this driver is interfacing as a regular
> platform device driver. In the future DT support will be
> submitted as an incremental feature patch.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've taken the patch in my tree.

-- 
Regards,

Laurent Pinchart

