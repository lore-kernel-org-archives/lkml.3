Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBYJiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:38:10 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:47251 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaBYJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:38:06 -0500
Date: Tue, 25 Feb 2014 09:37:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        khilman@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 01/14] mfd: omap-usb-host: Get clocks based on
 hardware revision
Message-ID: <20140225093759.GA22755@lee--X1>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
 <1392896409-5101-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392896409-5101-2-git-send-email-rogerq@ti.com>
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
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c | 43 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 11 deletions(-)

What about patches 1 and 2. Are these safe to go in alone?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
