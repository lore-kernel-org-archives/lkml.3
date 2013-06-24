Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3FXKwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:52:51 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:57533 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3FXKws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:52:48 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jun 2013 06:52:48 EDT
Message-ID: <51C82369.1080900@atmel.com>
Date: Mon, 24 Jun 2013 18:46:01 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: at91/PMC: at91sam9n12 family has USB HS feature
References: <cover.1372064763.git.nicolas.ferre@atmel.com> <a3b28f9041482ff60ed0b1b7a6f11d0b1beb5163.1372064763.git.nicolas.ferre@atmel.com>
In-Reply-To: <a3b28f9041482ff60ed0b1b7a6f11d0b1beb5163.1372064763.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 06/24/2013 05:08 PM, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/mach-at91/clock.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
> index 978de42..1b9bbba 100644
> --- a/arch/arm/mach-at91/clock.c
> +++ b/arch/arm/mach-at91/clock.c
> @@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(at91_pmc_base);
>   #define cpu_has_udpfs()		(!(cpu_is_at91sam9rl() \
>   				|| cpu_is_at91sam9g45() \
>   				|| cpu_is_at91sam9x5() \
> +				|| cpu_is_at91sam9n12() \
>   				|| cpu_is_sama5d3()))

The at91sam9n12 don't have USB HS device port feature. It only has USB 
FS device port feature.

>   #define cpu_has_plladiv2()	(cpu_is_at91sam9g45() \
>

Best Regards,
Bo Shen
