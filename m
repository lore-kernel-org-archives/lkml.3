Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaCHGew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 01:34:52 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:53800 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCHGev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 01:34:51 -0500
MIME-Version: 1.0
In-Reply-To: <1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Sat, 8 Mar 2014 14:34:50 +0800
Message-ID: <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig parameter
From: Lennox Wu <lennox.wu@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Michael,
According to my record, I had told you we have another
processor(2013/11/4), hence, we need the parameter.
We just wirte it done first. Do you remember it?

Best,
Lennox


2014-03-08 13:26 GMT+08:00 Michael Opdenacker
<michael.opdenacker@free-electrons.com>:
> This removes the CPU_SCORE7 Kconfig parameter,
> which is no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  arch/score/Kconfig | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> index c75d06aa27c3..4ac8cae5727c 100644
> --- a/arch/score/Kconfig
> +++ b/arch/score/Kconfig
> @@ -22,27 +22,21 @@ choice
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
> 1.8.3.2
>
