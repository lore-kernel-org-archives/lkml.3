Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3KDOwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:52:09 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59449 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab3KDOwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:52:06 -0500
MIME-Version: 1.0
In-Reply-To: <1383559081-5460-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1383559081-5460-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Mon, 4 Nov 2013 22:52:05 +0800
Message-ID: <CAF0htA7zWnqyHYkZ7UzLMVCHsH93v6Au=Euhgg6P7o__EpD48g@mail.gmail.com>
Subject: Re: [PATCH] score: remove unused CPU_SCORE7 Kconfig parameter
From: Lennox Wu <lennox.wu@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Liqin Chen <liqin.linux@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,
We have another processor, the parameter will be used to differentiate
the different processors.
Anyway, thank you. :)

Best,
Lennox


2013/11/4 Michael Opdenacker <michael.opdenacker@free-electrons.com>:
> This removes the CPU_SCORE7 Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/score/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> index 305f7ee1f382..2bc03d04f3af 100644
> --- a/arch/score/Kconfig
> +++ b/arch/score/Kconfig
> @@ -23,27 +23,21 @@ choice
>  config ARCH_SCORE7
>         bool "SCORE7 processor"
>         select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
>         select GENERIC_HAS_IOMAP
>
>  config MACH_SPCT6600
>         bool "SPCT6600 series based machines"
>         select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
>         select GENERIC_HAS_IOMAP
>
>  config SCORE_SIM
>         bool "Score simulator"
>         select SYS_SUPPORTS_32BIT_KERNEL
> -       select CPU_SCORE7
>         select GENERIC_HAS_IOMAP
>  endchoice
>
>  endmenu
>
> -config CPU_SCORE7
> -       bool
> -
>  config NO_DMA
>         bool
>         default y
> --
> 1.8.1.2
>
