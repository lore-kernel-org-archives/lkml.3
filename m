Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaLALMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:12:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:55338 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaLALMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:12:43 -0500
Message-ID: <547C4D29.10802@atmel.com>
Date: Mon, 1 Dec 2014 12:12:41 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: atmel-hlcdc: Add Kconfig option description and
 name
References: <1417431156-4914-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417431156-4914-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 11:52, Boris Brezillon a écrit :
> The MFD_ATMEL_HLCDC was first intended to be selected by its sub-devices
> but these sub-devices now depends on this option, we thus need to add
> a name and a description so that users can see it.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Okay:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, bye.

> ---
>  drivers/mfd/Kconfig | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
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
> 


-- 
Nicolas Ferre
