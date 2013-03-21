Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab3CUFgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:36:25 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:19152 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108Ab3CUFgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:36:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAOebSlGVhxBY/2dsb2JhbAANNsU6gW6DGAEBAQQ4QAEQCw4KCRYPCQMCAQIBRQYNAQUCAQGHfQGvL5MmjxAHg0ADqn4
X-IronPort-AV: E=Sophos;i="4.84,883,1355068800"; 
   d="scan'208";a="322847480"
Message-ID: <514A9C19.8080008@westnet.com.au>
Date: Thu, 21 Mar 2013 15:35:21 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [RFC 2/3] m68k: coldfire: use gpiolib
References: <1363527723-32713-1-git-send-email-acourbot@nvidia.com> <1363527723-32713-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1363527723-32713-3-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/13 23:42, Alexandre Courbot wrote:
> Force use of gpiolib for Coldfire, as a step towards the deprecation of
> GENERIC_GPIO.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>   arch/m68k/Kconfig.cpu | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
> index b1cfff8..d266787 100644
> --- a/arch/m68k/Kconfig.cpu
> +++ b/arch/m68k/Kconfig.cpu
> @@ -22,8 +22,7 @@ config M68KCLASSIC
>
>   config COLDFIRE
>   	bool "Coldfire CPU family support"
> -	select GENERIC_GPIO
> -	select ARCH_WANT_OPTIONAL_GPIOLIB
> +	select ARCH_REQUIRE_GPIOLIB
>   	select ARCH_HAVE_CUSTOM_GPIO_H
>   	select CPU_HAS_NO_BITFIELDS
>   	select CPU_HAS_NO_MULDIV64
>

