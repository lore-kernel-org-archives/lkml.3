Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaGBIZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:25:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41349 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbaGBIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:25:08 -0400
Date: Wed, 2 Jul 2014 10:25:05 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/33] ARM: at91: move at91rm9200 SoC to the CCF
Message-ID: <20140702102505.3fa92b0f@bbrezillon>
In-Reply-To: <1404223962-30471-7-git-send-email-alexandre.belloni@free-electrons.com>
References: <1404223962-30471-1-git-send-email-alexandre.belloni@free-electrons.com>
	<1404223962-30471-7-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Jul 2014 16:12:15 +0200
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> This patch removes the selection of AT91_USE_OLD_CLK when selecting
> at91rm9200 SoC support. This will automatically enable
> COMMON_CLK_AT91 option and add support for at91 common clk
> implementation.
> 

Acked-by: Boris BREZILLON <boris.brezillon@free-electrons.com>

> Signed-off-by: Alexandre Belloni
> <alexandre.belloni@free-electrons.com> ---
>  arch/arm/mach-at91/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 45b55e0f0db6..c818136a74b8 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -113,7 +113,6 @@ config SOC_AT91RM9200
>  	select HAVE_AT91_DBGU0
>  	select MULTI_IRQ_HANDLER
>  	select SPARSE_IRQ
> -	select AT91_USE_OLD_CLK
>  	select HAVE_AT91_USB_CLK
>  
>  config SOC_AT91SAM9260



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
