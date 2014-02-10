Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaBJCYs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:24:48 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:57710 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaBJCYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:24:46 -0500
MIME-Version: 1.0
In-Reply-To: <1391971686-9517-17-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-17-git-send-email-richard@nod.at>
Date: Mon, 10 Feb 2014 10:24:45 +0800
Message-ID: <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Lennox Wu <lennox.wu@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Chen Liqin <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Acked-by: Lennox Wu <lennox.wu@gmail.com>

2014-02-10 2:47 GMT+08:00 Richard Weinberger <richard@nod.at>:
> The symbol is an orphan, get rid of it.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/score/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> index c75d06a..c7a7b65 100644
> --- a/arch/score/Kconfig
> +++ b/arch/score/Kconfig
> @@ -23,19 +23,16 @@ config ARCH_SCORE7
>         bool "SCORE7 processor"
>         select SYS_SUPPORTS_32BIT_KERNEL
>         select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
>
>  config MACH_SPCT6600
>         bool "SPCT6600 series based machines"
>         select SYS_SUPPORTS_32BIT_KERNEL
>         select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
>
>  config SCORE_SIM
>         bool "Score simulator"
>         select SYS_SUPPORTS_32BIT_KERNEL
>         select CPU_SCORE7
> -       select GENERIC_HAS_IOMAP
>  endchoice
>
>  endmenu
> --
> 1.8.4.2
>
