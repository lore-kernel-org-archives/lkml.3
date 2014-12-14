Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaLNQZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:25:21 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:32825 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaLNQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:25:19 -0500
MIME-Version: 1.0
In-Reply-To: <tip-f0905c5a32ce6e9b743b4d9c70e53d1ce447852d@git.kernel.org>
References: <1042001e502f8e0deb0edfeeac209b68378650cf.1418430292.git.luto@amacapital.net>
 <tip-f0905c5a32ce6e9b743b4d9c70e53d1ce447852d@git.kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 14 Dec 2014 08:24:57 -0800
Message-ID: <CALCETrV4RD=aDD0b8x=ta9jVpRi4OEi6ThuEtpGpRVaweab=VQ@mail.gmail.com>
Subject: Re: [tip:x86/urgent] MAINTAINERS: Add me as x86 VDSO submaintainer
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2014 11:54 PM, "tip-bot for Andy Lutomirski"
<tipbot@zytor.com> wrote:
>
> Commit-ID:  f0905c5a32ce6e9b743b4d9c70e53d1ce447852d
> Gitweb:     http://git.kernel.org/tip/f0905c5a32ce6e9b743b4d9c70e53d1ce447852d
> Author:     Andy Lutomirski <luto@amacapital.net>
> AuthorDate: Fri, 12 Dec 2014 16:25:47 -0800
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sun, 14 Dec 2014 08:47:22 +0100
>
> MAINTAINERS: Add me as x86 VDSO submaintainer
>
> Here goes... :)
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1042001e502f8e0deb0edfeeac209b68378650cf.1418430292.git.luto@amacapital.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  MAINTAINERS | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c444907..7a54fa8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10295,6 +10295,13 @@ L:     linux-edac@vger.kernel.org
>  S:     Maintained
>  F:     arch/x86/kernel/cpu/mcheck/*
>
> +X86 VDSO
> +M:     Andy Lutomirski <luto@amacapital.net>
> +L:     linux-kernel@vger.kernel.org
> +T:     git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso

Unless this choice of git tree is actually sensible, v2 of this patch has:

git git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git x86/vdso

which makes more sense, I think.

--Andy

> +S:     Maintained
> +F:     arch/x86/vdso/
> +
>  XC2028/3028 TUNER DRIVER
>  M:     Mauro Carvalho Chehab <m.chehab@samsung.com>
>  L:     linux-media@vger.kernel.org
