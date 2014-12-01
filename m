Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaLAMsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:48:20 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:65266 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbaLAMsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:48:19 -0500
Date: Mon, 1 Dec 2014 12:48:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: atmel-hlcdc: Add Kconfig option description and name
Message-ID: <20141201124812.GB12068@x1>
References: <1417431156-4914-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417431156-4914-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2014, Boris Brezillon wrote:

> The MFD_ATMEL_HLCDC was first intended to be selected by its sub-devices
> but these sub-devices now depends on this option, we thus need to add
> a name and a description so that users can see it.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/mfd/Kconfig | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c9200d3..4a637f4 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -60,10 +60,15 @@ config MFD_AAT2870_CORE
>  	  functionality of the device.
>  
>  config MFD_ATMEL_HLCDC
> -	tristate
> +	tristate "Atmel HLCDC (High-end LCD Controller)"
>  	select MFD_CORE
>  	select REGMAP_MMIO
>  	depends on OF
> +	help
> +	  If you say yes here you get support for the HLCDC block.
> +	  This driver provides common support for accessing the device,
> +	  additional drivers must be enabled in order to use the
> +	  functionality of the device.
>  
>  config MFD_BCM590XX
>  	tristate "Broadcom BCM590xx PMUs"

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
