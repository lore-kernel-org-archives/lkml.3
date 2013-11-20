Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3KTKQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:16:36 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:33677 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3KTKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:16:31 -0500
Message-ID: <528C8BF8.4080803@atmel.com>
Date: Wed, 20 Nov 2013 11:16:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        <linux@maxim.org.za>, <plagnioj@jcrosoft.com>,
        Yanis Moreno <yanis.moreno63@gmail.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: remove redundant dependency
References: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1384932191-8967-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/11/2013 08:23, Michael Opdenacker :
> From: Yanis Moreno <yanis.moreno63@gmail.com>
>
> This removes the "depends on SOC_SAM_V7" statement
> in a Kconfig section that's under an "if SOC_SAM_V7"
> condition (same parameter).
>
> Signed-off-by: Yanis Moreno <yanis.moreno63@gmail.com>
> Reviewed-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks for this fix. Integrated in at91-3.14-cleanup branch.
Best regards.

> ---
>   arch/arm/mach-at91/Kconfig |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 699b71e..d1b3fe5 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -61,7 +61,6 @@ comment "Atmel AT91 Processor"
>   if SOC_SAM_V7
>   config SOC_SAMA5D3
>   	bool "SAMA5D3 family"
> -	depends on SOC_SAM_V7
>   	select SOC_SAMA5
>   	select HAVE_FB_ATMEL
>   	select HAVE_AT91_DBGU1
>


-- 
Nicolas Ferre
