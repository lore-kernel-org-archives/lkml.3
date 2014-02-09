Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaBIUyH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 15:54:07 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:63405 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaBIUyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:54:04 -0500
Message-ID: <1391979242.25855.37.camel@x220>
Subject: Re: [PATCH 15/28] Remove TI_AEMIF
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "open list:MEMORY TECHNOLOGY..." <linux-mtd@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 21:54:02 +0100
In-Reply-To: <1391971686-9517-16-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-16-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 20:54:02.0906 (UTC) FILETIME=[10534FA0:01CF25D9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/nand/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 90ff447..a195d57 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -465,7 +465,7 @@ config MTD_NAND_SH_FLCTL
>  
>  config MTD_NAND_DAVINCI
>          tristate "Support NAND on DaVinci/Keystone SoC"
> -        depends on ARCH_DAVINCI || (ARCH_KEYSTONE && TI_AEMIF)
> +        depends on ARCH_DAVINCI || ARCH_KEYSTONE
>          help
>  	  Enable the driver for NAND flash chips on Texas Instruments
>  	  DaVinci/Keystone processors.

What's strange about the current dependency is that the only aemif code
I could find lives at arch/arm/mach-davinci/aemif.c. Is that reachable
for code in arch/arm/mach-keystone?


Paul Bolle

