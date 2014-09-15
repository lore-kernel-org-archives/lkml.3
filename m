Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaIOJS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:18:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:2279 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaIOJS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:18:26 -0400
Message-ID: <5416AEE2.4070303@atmel.com>
Date: Mon, 15 Sep 2014 11:18:26 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 7/8] ARM: at91: add sama5d4 support to sama5_defconfig
References: <1410536587-24607-1-git-send-email-alexandre.belloni@free-electrons.com> <1410536587-24607-8-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1410536587-24607-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 17:43, Alexandre Belloni :
> Add sama5d4 to sama5_defconfig to build kernel booting on both sama5d3 and
> samad4.
> 
> Note that earlyprintk can only be working for one or the other.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/configs/sama5_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index 96c15b775d57..c9089c927daf 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -19,6 +19,7 @@ CONFIG_MODULE_FORCE_UNLOAD=y
>  CONFIG_ARCH_AT91=y
>  CONFIG_SOC_SAM_V7=y
>  CONFIG_SOC_SAMA5D3=y
> +CONFIG_SOC_SAMA5D4=y
>  CONFIG_MACH_SAMA5_DT=y
>  CONFIG_AEABI=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
> 


-- 
Nicolas Ferre
