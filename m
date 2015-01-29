Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbbA2O13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:27:29 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61422 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbA2O11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:27:27 -0500
MIME-Version: 1.0
In-Reply-To: <1417707288-675-1-git-send-email-geert+renesas@glider.be>
References: <1417707288-675-1-git-send-email-geert+renesas@glider.be>
Date: Thu, 29 Jan 2015 15:27:25 +0100
X-Google-Sender-Auth: e0iCR03gpF4kHjilVnyG_AkzraM
Message-ID: <CAMuHMdVBT8UHixD24HL=-qE6isH7hx8BH__R8LDNuSUh4GcSsw@mail.gmail.com>
Subject: Re: [PATCH] power: Use subdir-ccflags-* to inherit debug flag
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Thu, Dec 4, 2014 at 4:34 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Use subdir-ccflags-* instead of ccflags-* to inherit the debug
> settings from Kconfig when traversing subdirectories.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/power/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index dfa89427392636ed..845e2e25b016f04e 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -1,4 +1,4 @@
> -ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
> +subdir-ccflags-$(CONFIG_POWER_SUPPLY_DEBUG) := -DDEBUG
>
>  power_supply-y                         := power_supply_core.o
>  power_supply-$(CONFIG_SYSFS)           += power_supply_sysfs.o
> --
> 1.9.1

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
