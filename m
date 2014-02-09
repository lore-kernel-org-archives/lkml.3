Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBIUDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:03:23 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:57827 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbaBIUDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:03:21 -0500
Message-ID: <1391976161.25855.16.camel@x220>
Subject: Re: [PATCH 03/28] Remove MACH_BCM2708
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "open list:DMA GENERIC OFFLO..." <dmaengine@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:02:41 +0100
In-Reply-To: <1391971686-9517-4-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-4-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:02:41.0668 (UTC) FILETIME=[E3C3B440:01CF25D1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/dma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 9bed1a2..e4382ec 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -308,7 +308,7 @@ config DMA_OMAP
>  
>  config DMA_BCM2835
>  	tristate "BCM2835 DMA engine support"
> -	depends on (ARCH_BCM2835 || MACH_BCM2708)
> +	depends on ARCH_BCM2835
>  	select DMA_ENGINE
>  	select DMA_VIRTUAL_CHANNELS
>  

I sent an identical patch (with a more verbose explanation) a few hours
ago. But I'm fine with this one too.


Paul Bolle

