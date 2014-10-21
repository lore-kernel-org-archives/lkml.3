Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaJUJxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:53:08 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59071 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaJUJxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
References: <20141020144448.59e2e067d632c70353296e56@linux-foundation.org>
	<a6b3d86db6f5d19f7130b8dba2703dda68cb14d5.1413842560.git.luto@amacapital.net>
Date: Tue, 21 Oct 2014 11:53:04 +0200
X-Google-Sender-Auth: X9iLRf653rj3GvMSSmkFzIebx6g
Message-ID: <CAMuHMdWrXaJnfuyxOP-4zQyYJwrho6XvbTcjtwNK4pgoSH9PFw@mail.gmail.com>
Subject: Re: [PATCH] init: Remove CONFIG_INIT_FALLBACK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, Rob Landley <rob@landley.net>,
        Frank Rowand <frowand.list@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Shuah Khan <shuah.kh@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:04 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> CONFIG_INIT_FALLBACK adds config bloat without an obvious use case
> that makes it worth keeping around.  Delete it.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>
> Bring on the blame :)
>
>  init/Kconfig | 16 ----------------
>  init/main.c  |  5 -----
>  2 files changed, 21 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index ebbd5846478e..e84c6423a2e5 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1299,22 +1299,6 @@ source "usr/Kconfig"
>
>  endif
>
> -config INIT_FALLBACK
> -       bool "Fall back to defaults if init= parameter is bad"
> -       default y
> -       help

The above is not in mainline, nor in -next?
Seems it only exists in a patch series you sent yourself?

Confused...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
