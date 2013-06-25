Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab3FYFMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:12:23 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:19624 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750708Ab3FYFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:12:22 -0400
Message-ID: <51C9264C.6050400@atmel.com>
Date: Tue, 25 Jun 2013 13:10:36 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91/PMC: fix at91sam9n12 USB FS init
References: <1372071462-29063-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1372071462-29063-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 06/24/2013 06:57 PM, Nicolas Ferre wrote:
> at91sam9n12 has Full-speed only USB. So we should add
> it to the list in at91_pllb_usbfs_clock_init() function.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/mach-at91/clock.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 978de42..2f732d9 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -699,7 +699,7 @@ static void __init at91_pllb_usbfs_clock_init(unsigned long main_clock)
>   		at91_pmc_write(AT91_PMC_SCER, AT91RM9200_PMC_MCKUDP);
>   	} else if (cpu_is_at91sam9260() || cpu_is_at91sam9261() ||
>   		   cpu_is_at91sam9263() || cpu_is_at91sam9g20() ||
> -		   cpu_is_at91sam9g10()) {
> +		   cpu_is_at91sam9g10() || cpu_is_at91sam9n12()) {
>   		uhpck.pmc_mask = AT91SAM926x_PMC_UHP;
>   		udpck.pmc_mask = AT91SAM926x_PMC_UDP;
>   	}
>

As you post the following patches:
   ARM: at91/PMC: fix at91sam9n12 USB FS init 
(https://patchwork.kernel.org/patch/2772301/)

This patch no need anymore.

Best Regards,
Bo Shen
