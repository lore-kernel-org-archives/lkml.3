Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaCJOcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:32:14 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:49918 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaCJOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:32:12 -0400
Date: Mon, 10 Mar 2014 14:32:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v9 3/9] mfd: omap-usb-host: Use proper clock name instead
 of alias
Message-ID: <20140310143207.GD15558@lee--X1>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <1393510711-4697-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393510711-4697-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use the proper clock name 'usbhost_120m_fck' instead of the
> alias 'ehci_logic_fck'
> 
> Get rid of the 'ehci_logic_fck' alias from the OMAP3 hwmod data
> as well.
> 
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 6 ------
>  drivers/mfd/omap-usb-host.c                | 5 +++--
>  2 files changed, 3 insertions(+), 8 deletions(-)

So long as the platform guys are okay with the semantic change, the
MFD diff looks okay to me. For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
