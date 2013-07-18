Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab3GRUAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:00:55 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33260 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab3GRUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130718183201.GA21183@www.outflux.net>
References: <20130718183201.GA21183@www.outflux.net>
Date: Thu, 18 Jul 2013 22:00:49 +0200
X-Google-Sender-Auth: NmJwnAV_Wji1YifwppDpNM_uu0M
Message-ID: <CAMuHMdX4dj3q53RsWTTmo-AOU1ee-xgp257CwacJnHfWn0BEAQ@mail.gmail.com>
Subject: Re: [PATCH v2] kconfig: switch to "long long" for sanity
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 8:32 PM, Kees Cook <keescook@chromium.org> wrote:
> Instead of using "long" for kconfig "hex" and "range" values, which may
> change in size depending on the host architecture, use "long long". This
> will allow values greater than INT_MAX on 32-bit hosts when cross
> compiling.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
