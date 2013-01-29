Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3A2Wkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:40:39 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38418 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3A2Wkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:40:36 -0500
MIME-Version: 1.0
In-Reply-To: <1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com>
	<1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 29 Jan 2013 23:40:34 +0100
Message-ID: <CACRpkdbZhS1APd6bFEnh9OLJEnNMgtFOCmW8vz1fVP3+yKy7LQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] ARM: sunxi: Increase the number of GPIOs available
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>, arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 3:36 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The Allwinner A10 has 9 banks of 32 GPIOs available, so it doesn't fit
> in the usual 256 limit set by gpio.h. Increase this number to 288.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index f95ba14..1e86fa9 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1632,7 +1632,7 @@ config ARCH_NR_GPIO
>         default 355 if ARCH_U8500
>         default 264 if MACH_H4700
>         default 512 if SOC_OMAP5
> -       default 288 if ARCH_VT8500
> +       default 288 if ARCH_VT8500 || ARCH_SUNXI

Can I have an ACK from the ARM SoC maintainers on this?

Yours,
Linus Walleij
