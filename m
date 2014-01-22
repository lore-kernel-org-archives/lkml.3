Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaAVOLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:11:13 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:44540 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbaAVOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <1390336672-21921-1-git-send-email-geert@linux-m68k.org>
References: <1390336672-21921-1-git-send-email-geert@linux-m68k.org>
Date: Wed, 22 Jan 2014 22:11:09 +0800
Message-ID: <CAF0htA7nnzNtD20v418e1c8a6WvX2AO0q1Hi_e5kiuT-CSXXFA@mail.gmail.com>
Subject: Re: [PATCH] Score: Remove "select HAVE_GENERIC_HARDIRQS" again
From: Lennox Wu <lennox.wu@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chen Liqin <liqin.linux@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Lennox Wu <lennox.wu@gmail.com>

2014/1/22 Geert Uytterhoeven <geert@linux-m68k.org>:
> Commit 5fbbf8a1a93452b26e7791cf32cefce62b0a480b ("Score: The commit is for
> compiling successfully.") re-introduced "select HAVE_GENERIC_HARDIRQS" in
> v3.12-rc4, which had just been removed in v3.12-rc1 by commit
> 0244ad004a54e39308d495fee0a2e637f8b5c317 ("Remove GENERIC_HARDIRQ config
> option").
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/score/Kconfig |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> index 305f7ee1f382..c75d06aa27c3 100644
> --- a/arch/score/Kconfig
> +++ b/arch/score/Kconfig
> @@ -2,7 +2,6 @@ menu "Machine selection"
>
>  config SCORE
>         def_bool y
> -       select HAVE_GENERIC_HARDIRQS
>         select GENERIC_IRQ_SHOW
>         select GENERIC_IOMAP
>         select GENERIC_ATOMIC64
> --
> 1.7.9.5
>
