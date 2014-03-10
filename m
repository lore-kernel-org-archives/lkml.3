Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbaCJOSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:18:01 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51704 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaCJOR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:17:59 -0400
Date: Mon, 10 Mar 2014 14:17:54 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v9 2/9] mfd: omap-usb-host: Always fail on clk_get() error
Message-ID: <20140310141754.GC15558@lee--X1>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
 <1393510711-4697-3-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393510711-4697-3-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Be more strict and always fail on clk_get() error.
> 
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c | 62 +++++++++++++++++++++++++++++----------------
>  1 file changed, 40 insertions(+), 22 deletions(-)

I like to principle of the patch assuming that the devices would be
useless without their clocks.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
