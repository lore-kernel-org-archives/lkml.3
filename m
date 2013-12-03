Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3LCVB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:01:29 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:36554 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3LCVB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:01:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131203204540.GA4796@roeck-us.net>
References: <1385891092-13266-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdV1hoUnYixPghCAy-LuTaB9JU-BFfBPH06gxhLRAqfp8Q@mail.gmail.com>
	<20131203204540.GA4796@roeck-us.net>
Date: Tue, 3 Dec 2013 22:01:27 +0100
X-Google-Sender-Auth: Uv_eVyDrfh1RQkLEmJfYiZ1QP8o
Message-ID: <CAMuHMdXsn9R6-R5yMCnjEmum5LjBRmL8+v+_ryvRLJyQBg1ZtA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.13-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 9:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> ia64-defconfig:
>
> arch/ia64/kernel/built-in.o: In function `skip_rbs_switch':
> (.text+0xef2): undefined reference to `preempt_schedule_irq'

Funny, that one was actually introduced in v3.13-rc1, but it fell through
the cracks of the regex handling in my script.

BTW, my scripts are back online: https://github.com/geertu/linux-scripts.
linux-log-diff didn't see the ia64 breakage, linux-log-summary did.
One day I plan to merge linux-log-diff and linux-log-summary, so I have
to maintain only one regex chain.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
