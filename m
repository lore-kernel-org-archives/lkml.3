Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaDNI60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:58:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57041 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754292AbaDNI6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:58:22 -0400
Date: Mon, 14 Apr 2014 10:58:09 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: at91: move sam9n12 SoC to the CCF
Message-ID: <20140414085809.GN2967@piout.net>
References: <1397463399-11771-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397463399-11771-5-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397463399-11771-5-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/2014 at 10:16:39 +0200, Boris Brezillon wrote :
> This patch removes the selection of AT91_USE_OLD_CLK when selecting
> sam9n12 SoC support. This will automatically enable COMMON_CLK_AT91 option
> and add support for at91 common clk implementation.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/mach-at91/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index b2d2cf4..a1ac430 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -183,7 +183,6 @@ config SOC_AT91SAM9N12
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> -	select AT91_USE_OLD_CLK
>  	select HAVE_AT91_USB_CLK
>  	help
>  	  Select this if you are using Atmel's AT91SAM9N12 SoC.
> -- 
> 1.8.3.2
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
