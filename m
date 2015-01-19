Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164AbbASFAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:00:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42791 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbbASFAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:00:04 -0500
Message-ID: <54BC8F2B.10509@ti.com>
Date: Mon, 19 Jan 2015 10:29:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Kevin Hilman <khilman@deeprootsystems.com>
CC: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: mach-davinci: Remove driver CDCE949
References: <1421624259-24127-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1421624259-24127-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 19 January 2015 05:07 AM, Rickard Strandqvist wrote:
> Remove driver CDCE949 because it is not used anywhere.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>


> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index ae129bc..8be5aef 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -45,7 +45,6 @@
>  #include <mach/irqs.h>
>  #include <mach/serial.h>
>  #include <mach/clock.h>
> -#include <mach/cdce949.h>
>  
>  #include "davinci.h"
>  #include "clock.h"
> @@ -399,9 +398,6 @@ static struct i2c_board_info __initdata i2c_info[] =  {
>  	{
>  		I2C_BOARD_INFO("cpld_video", 0x3b),
>  	},
> -	{
> -		I2C_BOARD_INFO("cdce949", 0x6c),
> -	},
>  };

There is cdce_clk_init() and associated data structures that also need
to be removed.

Thanks,
Sekhar

