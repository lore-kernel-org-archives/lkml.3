Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaDNJM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:12:56 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979AbaDNJMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:12:55 -0400
Date: Mon, 14 Apr 2014 11:10:03 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: at91: move sam9x5 SoCs to the CCF
Message-ID: <20140414091002.GR2967@piout.net>
References: <1397464994-27267-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397464994-27267-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397464994-27267-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 at 10:43:14 +0200, Boris Brezillon wrote :
> This patch removes the selection of AT91_USE_OLD_CLK when selecting
> sam9x5 SoCs support. This will automatically enable COMMON_CLK_AT91 option
> and add support for at91 common clk implementation.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index a1ac430..45b55e0 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -167,7 +167,6 @@ config SOC_AT91SAM9X5
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> -	select AT91_USE_OLD_CLK
>  	select HAVE_AT91_UTMI
>  	select HAVE_AT91_SMD
>  	select HAVE_AT91_USB_CLK
> -- 
> 1.8.3.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
