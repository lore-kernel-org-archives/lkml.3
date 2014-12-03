Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaLCQVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:21:16 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:37206 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaLCQVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:21:14 -0500
Message-ID: <547F3876.70207@atmel.com>
Date: Wed, 3 Dec 2014 17:21:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 07/11] ARM: at91: select ATMEL_EBI when compiling a
 kernel for at91sam9 or sama5d3
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <1417429647-3419-8-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417429647-3419-8-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 11:27, Boris Brezillon a écrit :
> at91sam9* and sama5d* SoCs have an EBI (External Bus Interface).
> Select the ATMEL_EBI driver when support for these SoCs is selected.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  arch/arm/mach-at91/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 0e6d548..a72402a 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -49,6 +49,7 @@ config SOC_AT91SAM9
>  	select GENERIC_CLOCKEVENTS
>  	select MEMORY if USE_OF
>  	select ATMEL_SDRAMC if USE_OF
> +	select ATMEL_EBI if USE_OF

We can remove "USE_OF" for next version.

>  config SOC_SAMA5
>  	bool
> @@ -58,6 +59,7 @@ config SOC_SAMA5
>  	select USE_OF
>  	select MEMORY
>  	select ATMEL_SDRAMC
> +	select ATMEL_EBI
>  
>  menu "Atmel AT91 System-on-Chip"
>  
> 


-- 
Nicolas Ferre
