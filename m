Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaAJKLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:11:17 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43199 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAJKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:11:13 -0500
Date: Fri, 10 Jan 2014 10:11:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: bcousson@baylibre.com, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        sre@debian.org, mark.rutland@arm.com, m.paolino@virtualopensystems.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v5 3/9] mfd: omap-usb-host: Update DT clock binding
 information
Message-ID: <20140110101107.GF28141@lee--X1>
References: <1389269303-30465-1-git-send-email-rogerq@ti.com>
 <1389269303-30465-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389269303-30465-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014, Roger Quadros wrote:

> The omap-usb-host driver expects certained named clocks.
> Add this information to the DT binding document.
> 
> Use clock names as per function for reference clocks.
> 
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  .../devicetree/bindings/mfd/omap-usb-host.txt      | 23 ++++++++++++++++++++++
>  drivers/mfd/omap-usb-host.c                        |  6 +++---
>  2 files changed, 26 insertions(+), 3 deletions(-)

Please don't mix up binding changes with code ones.

Separate patch please.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
