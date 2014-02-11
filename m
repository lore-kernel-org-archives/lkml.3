Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBKMIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:08:19 -0500
Received: from smtp-out-081.synserver.de ([212.40.185.81]:1079 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbaBKMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:08:18 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22149
Message-ID: <52FA12B2.5090906@metafoo.de>
Date: Tue, 11 Feb 2014 13:08:18 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Ralf Baechle'" <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 4/7] MIPS: jz4740: don't select HAVE_PWM
References: <003901cf25fc$73002790$590076b0$%han@samsung.com> <003d01cf25fd$309c58a0$91d509e0$%han@samsung.com>
In-Reply-To: <003d01cf25fd$309c58a0$91d509e0$%han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 02:12 AM, Jingoo Han wrote:
> The HAVE_PWM symbol is only for legacy platforms that provide
> the PWM API without using the generic framework. The jz4740
> platform uses the generic PWM framework, after the commit "f6b8a57
> pwm: Add Ingenic JZ4740 support".
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>   arch/mips/Kconfig |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index dcae3a7..d132603 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -235,7 +235,6 @@ config MACH_JZ4740
>   	select IRQ_CPU
>   	select ARCH_REQUIRE_GPIOLIB
>   	select SYS_HAS_EARLY_PRINTK
> -	select HAVE_PWM
>   	select HAVE_CLK
>   	select GENERIC_IRQ_CHIP
>
>

