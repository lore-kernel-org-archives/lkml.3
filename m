Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaCJOev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:34:51 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:65125 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaCJOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:34:49 -0400
Date: Mon, 10 Mar 2014 14:34:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v9 4/9] mfd: omap-usb-host: Use clock names as per
 function for reference clocks
Message-ID: <20140310143443.GE15558@lee--X1>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <1393510711-4697-5-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393510711-4697-5-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use a meaningful name for the reference clocks so that it indicates the function.
> 
> Update the OMAP4+ USB Host node as well to be in sync with the changes.
> 
> CC: Benoît Cousson <bcousson@baylibre.com>
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/boot/dts/omap4.dtsi |  6 ++++++
>  arch/arm/boot/dts/omap5.dtsi |  6 ++++++
>  drivers/mfd/omap-usb-host.c  | 12 ++++++------
>  3 files changed, 18 insertions(+), 6 deletions(-)

The code looks fine and I queried the name change semantics before and
was satisfied with your answer, so as long as this patch has been
tested and nothing is broken:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
