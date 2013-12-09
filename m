Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717Ab3LISEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:04:02 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:61777 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3LISD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:03:57 -0500
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com>
References: <CAPgLHd-Fjx1RybjWFAu1vHRfTvhWwMLL3x46BouC5uNxHPjy1A@mail.gmail.com>
Date: Mon, 9 Dec 2013 10:03:57 -0800
X-Google-Sender-Auth: 73X9S4I4MFk2pp8qqQ24V1VHaps
Message-ID: <CAGXu5jLq_CHdSNuCgenTZzyBaa=CjvnFOioxVyqRdB3FYro08A@mail.gmail.com>
Subject: Re: [PATCH -next] x86, kaslr: remove unused including <linux/version.h>
From: Kees Cook <keescook@chromium.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, yongjun_wei@trendmicro.com.cn,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 7, 2013 at 5:02 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Thanks, yeah, ultimately utsrelease.h had everything that was needed.

Acked-by: Kees Cook <keescook@chromium.org>

> ---
>  arch/x86/boot/compressed/aslr.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index 84be175..90a21f4 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -10,7 +10,6 @@
>  #include <linux/uts.h>
>  #include <linux/utsname.h>
>  #include <generated/utsrelease.h>
> -#include <linux/version.h>
>
>  /* Simplified build-specific string for starting entropy. */
>  static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
>

-Kees

-- 
Kees Cook
Chrome OS Security
