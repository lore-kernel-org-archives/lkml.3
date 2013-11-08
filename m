Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3KHIYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:24:42 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:37990 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KHIYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <1383854696.9263.25.camel@joe-AO722>
References: <1383854696.9263.25.camel@joe-AO722>
Date: Fri, 8 Nov 2013 09:24:37 +0100
Message-ID: <CAFLxGvynCXqu2xQaQyaH=U0cB4Z4GO83Fp=OPEGbUxR=Wdkang@mail.gmail.com>
Subject: Re: [RFC PATCH] MAINTAINERS: Remove Jaroslav Kysela
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 9:04 PM, Joe Perches <joe@perches.com> wrote:
> Jaroslav hasn't acked or signed a patch in quite awhile.
>
> Mark ISAPnp and HP VG/AnyLAN driver as orphan.
>
> Add sound to his CREDITS entry.

...didn't know that we have a maintainer police.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  CREDITS     | 1 +
>  MAINTAINERS | 7 ++-----
>  2 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/CREDITS b/CREDITS
> index 0640e16..01a1b34 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -2021,6 +2021,7 @@ E: perex@perex.cz
>  W: http://www.perex.cz
>  D: Original Author and Maintainer for HP 10/100 Mbit Network Adapters
>  D: ISA PnP
> +D: ALSA/Sound
>  S: Sindlovy Dvory 117
>  S: 370 01  Ceske Budejovice
>  S: Czech Republic
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 831b869..8706839 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3983,8 +3983,7 @@ S:        Orphan
>  F:     drivers/platform/x86/tc1100-wmi.c
>
>  HP100: Driver for HP 10/100 Mbit/s Voice Grade Network Adapter Series
> -M:     Jaroslav Kysela <perex@perex.cz>
> -S:     Maintained
> +S:     Orphan
>  F:     drivers/net/ethernet/hp/hp100.*
>
>  HPET:  High Precision Event Timers driver
> @@ -4600,8 +4599,7 @@ F:        include/linux/irqdomain.h
>  F:     kernel/irq/irqdomain.c
>
>  ISAPNP
> -M:     Jaroslav Kysela <perex@perex.cz>
> -S:     Maintained
> +S:     Orphan
>  F:     Documentation/isapnp.txt
>  F:     drivers/pnp/isapnp/
>  F:     include/linux/isapnp.h
> @@ -7818,7 +7816,6 @@ S:        Maintained
>  F:     drivers/memstick/core/ms_block.*
>
>  SOUND
> -M:     Jaroslav Kysela <perex@perex.cz>
>  M:     Takashi Iwai <tiwai@suse.de>
>  L:     alsa-devel@alsa-project.org (moderated for non-subscribers)
>  W:     http://www.alsa-project.org/
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
