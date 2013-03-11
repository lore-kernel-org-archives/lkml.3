Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3CKT5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:57:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44776 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3CKT5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:57:23 -0400
MIME-Version: 1.0
In-Reply-To: <1363029780-2902-1-git-send-email-valentin.ilie@gmail.com>
References: <1363029780-2902-1-git-send-email-valentin.ilie@gmail.com>
Date: Mon, 11 Mar 2013 21:57:22 +0200
X-Google-Sender-Auth: AMc-rKsJ8wikHgOgbO4CbCOp9ms
Message-ID: <CAEnQRZDdOO9DAZoypCs5jV5Zy0u=btX-zQV7kxo6HxoXZxEN3w@mail.gmail.com>
Subject: Re: [PATCH] Arch: x86: kernel: smpboot.c: Remove unused variable
From: Daniel Baluta <dbaluta@ixiacom.com>
To: Valentin Ilie <valentin.ilie@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 9:23 PM, Valentin Ilie <valentin.ilie@gmail.com> wrote:
> Remove unused variable 'c'
>
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  arch/x86/kernel/smpboot.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a6ceaed..7bc998a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1367,7 +1367,6 @@ static inline void mwait_play_dead(void)
>         unsigned int highest_subcstate = 0;
>         int i;
>         void *mwait_ptr;
> -       struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
>
>         if (!this_cpu_has(X86_FEATURE_MWAIT))
>                 return;
> --
> 1.7.10.4

Hi Valentin,

I guess a better subject for this patch should be
x86, smpboot: Remove unused variable

Use git log arch/x86/kernel/smpboot.c to check previous commits.

thanks,
Daniel.
