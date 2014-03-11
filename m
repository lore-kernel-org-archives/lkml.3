Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaCKKv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:51:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48321 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaCKKvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <1380138892.17366.24.camel@joe-AO722>
References: <1380138892.17366.24.camel@joe-AO722>
Date: Tue, 11 Mar 2014 11:51:24 +0100
X-Google-Sender-Auth: Xs57ObzGOvsB7WQMFf5EdPI4obc
Message-ID: <CAMuHMdW0cojVgDmTK0nHpY=xGFkM=10fJFe=SFP6En8k7Uwxvw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 9:54 PM, Joe Perches <joe@perches.com> wrote:
> Mark it so.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e61c2e8..a386a22 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4414,7 +4414,7 @@ F:        arch/x86/kernel/tboot.c
>  INTEL WIRELESS WIMAX CONNECTION 2400
>  M:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>  M:     linux-wimax@intel.com
> -L:     wimax@linuxwimax.org
> +L:     wimax@linuxwimax.org (subscribers-only)
>  S:     Supported
>  W:     http://linuxwimax.org
>  F:     Documentation/wimax/README.i2400m
> @@ -9225,7 +9225,7 @@ F:        drivers/media/rc/winbond-cir.c
>  WIMAX STACK
>  M:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
>  M:     linux-wimax@intel.com
> -L:     wimax@linuxwimax.org
> +L:     wimax@linuxwimax.org (subscribers-only)
>  S:     Supported
>  W:     http://linuxwimax.org
>  F:     Documentation/wimax/README.wimax
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
