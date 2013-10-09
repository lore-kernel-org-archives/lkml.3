Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966Ab3JINMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 09:12:52 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13207 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3JINMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 09:12:51 -0400
Message-ID: <52555650.4080003@atmel.com>
Date: Wed, 9 Oct 2013 15:12:48 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/6] ARM: at91: move sama5d3 SoC to common clk
References: <1375951572-10829-1-git-send-email-b.brezillon@overkiz.com> <1375957794-11559-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375957794-11559-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:29, Boris BREZILLON :
> This patch removes the selection of AT91_USE_OLD_CLK when selecting sama5d3
> SoC support. This will enable automatically enable COMMON_CLK_AT91 option
> and add support for at91 common clk implementation.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

One big step!

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>   arch/arm/mach-at91/Kconfig |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 97033f7..b4f7d6f 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -86,7 +86,6 @@ config SOC_SAMA5D3
>   	select SOC_SAMA5
>   	select HAVE_FB_ATMEL
>   	select HAVE_AT91_DBGU1
> -	select AT91_USE_OLD_CLK
>   	select HAVE_AT91_UTMI
>   	select HAVE_AT91_SMD
>   	select HAVE_AT91_USB_CLK
>


-- 
Nicolas Ferre
