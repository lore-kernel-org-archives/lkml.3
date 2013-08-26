Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3HZLAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:00:43 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41819 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab3HZLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <521B2E75.1040802@asianux.com>
References: <521B2E75.1040802@asianux.com>
Date: Mon, 26 Aug 2013 13:00:39 +0200
X-Google-Sender-Auth: tnhjLLWhzCE7W9cKH6Myzyp0eY0
Message-ID: <CAMuHMdVXJvLfmNLFFW=TBLOi2_mVyZy+kr46oM5GVz_PK-bbvA@mail.gmail.com>
Subject: Re: [PATCH] h8300/kernel/setup.c: add "linux/initrd.h" to pass compiling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 12:31 PM, Chen Gang <gang.chen@asianux.com> wrote:
> --- a/arch/h8300/kernel/setup.c
> +++ b/arch/h8300/kernel/setup.c
> @@ -47,6 +47,9 @@
>  #include <asm/regs267x.h>
>  #endif
>
> +#if defined(CONFIG_BLK_DEV_INITRD)

Why have you added the #ifdef?

> +#include <linux/initrd.h>
> +#endif
>  #define STUBSIZE 0xc000

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
