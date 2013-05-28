Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab3E1OZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 10:25:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43415 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab3E1OZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 10:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1369232581-18923-4-git-send-email-lee.jones@linaro.org>
References: <1369232581-18923-1-git-send-email-lee.jones@linaro.org>
	<1369232581-18923-4-git-send-email-lee.jones@linaro.org>
Date: Tue, 28 May 2013 16:25:55 +0200
Message-ID: <CACRpkdZ8vf0sQuhonTpUoB7vV=UgmY1hiJwhDEphnCxH=MXK1w@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: ux500: Standardise Pinctrl compatible string for
 Nomadik based platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 4:22 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-nomadik/cpu-8815.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c
> index 59f6ff5..316fe82 100644
> --- a/arch/arm/mach-nomadik/cpu-8815.c
> +++ b/arch/arm/mach-nomadik/cpu-8815.c
> @@ -288,7 +288,7 @@ static struct of_dev_auxdata cpu8815_auxdata_lookup[] __initdata = {
>                 "gpio.2", NULL),
>         OF_DEV_AUXDATA("st,nomadik-gpio", NOMADIK_GPIO3_BASE,
>                 "gpio.3", NULL),
> -       OF_DEV_AUXDATA("stericsson,nmk-pinctrl-stn8815", 0,
> +       OF_DEV_AUXDATA("stericsson,stn8815-pinctrl", 0,
>                 "pinctrl-stn8815", NULL),
>         OF_DEV_AUXDATA("arm,primecell", NOMADIK_UART0_BASE,
>                 "uart0", NULL),

I've dropped this platform data in the HEAD (now also in ARM SoC)
after moving the pinctrl configuration to the DTS, so this no longer
applies.

Yours,
Linus Walleij
