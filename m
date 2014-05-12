Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbaELKL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:11:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:55037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaELKLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:11:25 -0400
Message-ID: <53709E4A.9090301@atmel.com>
Date: Mon, 12 May 2014 12:11:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        boris brezillon <b.brezillon@overkiz.com>
Subject: Re: [PATCH Resend] defconfig: sama5_defconfig: updated
References: <1398137574-5790-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1398137574-5790-1-git-send-email-wenyou.yang@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/2014 05:32, Wenyou Yang :
> due to enabling
> 	-- CONFIG_REGULATOR
> 	-- CONFIG_REGULATOR_ACT8865
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

With little modification: I didn't pushed these configuration options at
the end of the file but at their location: the one that is chosen while
running the "savedefconfig" make command.
This might avoid conflicts when adding more options to the
sama5_defconfig file.

I stack this modified one on top of our at91-3.16-cleanup2 branch.

thanks!

> ---
> Hi Nicolas,
> 
> It is a typo.
> This patch is based on the branch: at91-3.16-dt, not at91-3.10-dt of
> 	git://github.com/at91linux/linux-at91.git
> 
> Best Regards,
> Wenyou Yang
> 
>  arch/arm/configs/sama5_defconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index dc3881e..2b9891e 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -201,3 +201,5 @@ CONFIG_CRYPTO_DEV_ATMEL_TDES=y
>  CONFIG_CRYPTO_DEV_ATMEL_SHA=y
>  CONFIG_CRC_CCITT=m
>  CONFIG_CRC_ITU_T=m
> +CONFIG_REGULATOR=y
> +CONFIG_REGULATOR_ACT8865=y
> 


-- 
Nicolas Ferre
