Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3ENOyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:54:03 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4712 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707Ab3ENOyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:54:01 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <51924FE4.5000803@broadcom.com>
Date: Tue, 14 May 2013 07:53:24 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130404
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Paul Bolle" <pebolle@tiscali.nl>
cc: "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-bcm: drop "select GPIO_BCM"
References: <1368524085.1350.102.camel@x61.thuisdomein>
In-Reply-To: <1368524085.1350.102.camel@x61.thuisdomein>
X-WSS-ID: 7D8C918B2L815272092-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-05-14 02:34 AM, Paul Bolle wrote:
> A select statement for the Kconfig symbol GPIO_BCM was added in v3.8.
> But there's no symbol with that name. It's a nop so we can drop it.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Untested.
>
> 1) Patch assumes that https://lkml.org/lkml/2013/3/6/182 ("ARM:
> mach-bcm: drop "select GENERIC_TIME""), which got a Reviewed-by tag from
> Christian, was applied first.
>
>   arch/arm/mach-bcm/Kconfig | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index 764273e..322620d 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -8,7 +8,6 @@ config ARCH_BCM
>   	select CPU_V7
>   	select CLKSRC_OF
>   	select GENERIC_CLOCKEVENTS
> -	select GPIO_BCM
>   	select SPARSE_IRQ
>   	select TICK_ONESHOT
>   	help
Hi Paul,
  We are planning on submitting the driver for this option for review 
over the next couple of weeks, to get it in the 3.11 cycle. So this 
patch won't be necessary.

  Thanks,
    csd


