Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaFML4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:56:37 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:53602 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbaFML4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:56:35 -0400
Message-ID: <1402660592.28881.22.camel@x220>
Subject: Re: [PATCH] IBM Akebono: Remove obsolete config select
From: Paul Bolle <pebolle@tiscali.nl>
To: Alistair Popple <alistair@popple.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Fri, 13 Jun 2014 13:56:32 +0200
In-Reply-To: <1399018005-23136-1-git-send-email-alistair@popple.id.au>
References: <1398998002.2925.15.camel@pasglop>
	 <1399018005-23136-1-git-send-email-alistair@popple.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2014 11:56:32.0687 (UTC) FILETIME=[84EB6BF0:01CF86FE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 18:06 +1000, Alistair Popple wrote:
> The original implementation of MMC support for Akebono introduced a
> new configuration symbol (MMC_SDHCI_OF_476GTR). This symbol has been
> dropped in favour of using the generic platform driver however the
> select for this symbol was mistakenly left in the platform
> configuration.
> 
> This patch removes the obsolete symbol selection.
> 
> Signed-off-by: Alistair Popple <alistair@popple.id.au>

This patch hasn't yet entered linux-next nor Linus' tree. Is it queued
somewhere? If not, would a
    Acked-by: Paul Bolle <pebolle@tiscali.nl>

help to get this trivial patch queued for either of those trees?


Paul Bolle

> ---
>  arch/powerpc/platforms/44x/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
> index 8beec7d..908bf11 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -220,7 +220,6 @@ config AKEBONO
>  	select USB_EHCI_HCD_PLATFORM
>  	select MMC_SDHCI
>  	select MMC_SDHCI_PLTFM
> -	select MMC_SDHCI_OF_476GTR
>  	select ATA
>  	select SATA_AHCI_PLATFORM
>  	help

