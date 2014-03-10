Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbaCJOOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:14:49 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45316 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaCJOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:14:44 -0400
Date: Mon, 10 Mar 2014 14:14:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v9 1/9] mfd: omap-usb-host: Get clocks based on hardware
 revision
Message-ID: <20140310141439.GB15558@lee--X1>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <1393510711-4697-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393510711-4697-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not all revisions have all the clocks so get the necessary clocks
> based on hardware revision.
> 
> This should avoid un-necessary clk_get failure messages that were
> observed earlier.
> 
> Also remove the dummy USB host clocks from the OMAP3 clock data.
> These are no longer expected by the driver.
> 
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: Tero Kristo <t-kristo@ti.com>
> Acked-by: Mike Turquette <mturquette@linaro.org> [OMAP3 CLK data]
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/cclock3xxx_data.c |  4 ----
>  drivers/clk/ti/clk-3xxx.c             |  4 ----
>  drivers/mfd/omap-usb-host.c           | 43 ++++++++++++++++++++++++++---------
>  3 files changed, 32 insertions(+), 19 deletions(-)

Patches starting to take shape. I know that I've reviewed this patch
before, so if you've fixed-up all my previous comments you can have my
Ack for the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
