Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3BEN7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:59:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab3BEN7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:59:41 -0500
Date: Tue, 5 Feb 2013 14:59:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Johan Hovold <jhovold@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] ARM: at91/ide: remove unsused at91-ide Kconfig
 entry
In-Reply-To: <1360072415-6594-1-git-send-email-jhovold@gmail.com>
Message-ID: <alpine.LNX.2.00.1302051459090.2260@pobox.suse.cz>
References: <1352892034-18871-1-git-send-email-jhovold@gmail.com> <1360072415-6594-1-git-send-email-jhovold@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Johan Hovold wrote:

> Commit cf844751fb25e ("ARM: at91: drop ide driver in favor of the pata
> one") removed the at91-ide driver but did not remove the Kconfig entry.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> Resend of patch first posted mid-November with trivial added as CC. Perhaps it
> can go in via the AT91-folks, otherwise?

It doesn't seem to have reached trivial@kernel.org back then.

I am taking it now, thanks.

> 
> Thanks,
> Johan
> 
> 
>  drivers/ide/Kconfig | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
> index 5a26584..bfec4e6 100644
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -702,11 +702,6 @@ config BLK_DEV_IDE_TX4939
>  	depends on SOC_TX4939
>  	select BLK_DEV_IDEDMA_SFF
>  
> -config BLK_DEV_IDE_AT91
> -	tristate "Atmel AT91 (SAM9, CAP9, AT572D940HF) IDE support"
> -	depends on ARM && ARCH_AT91 && !ARCH_AT91RM9200 && !ARCH_AT91X40
> -	select IDE_TIMINGS
> -
>  config BLK_DEV_IDE_ICSIDE
>  	tristate "ICS IDE interface support"
>  	depends on ARM && ARCH_ACORN
> -- 
> 1.8.1.1
> 

-- 
Jiri Kosina
SUSE Labs
