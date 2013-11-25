Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3KYJHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:07:20 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:50512 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3KYJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:07:14 -0500
Date: Mon, 25 Nov 2013 10:07:10 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 02/24] avr32/uapi: Use Kbuild logic to provide
 <asm/types.h>
Message-ID: <20131125090710.GA13358@samfundet.no>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
 <1385369734-24893-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385369734-24893-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 25 Nov 2013 09:55:12 +0100 or thereabout, Geert Uytterhoeven wrote:
> Uapi <asm-generic/types.h> just includes <asm-generic/int-ll64.h>
> 

Thanks for cleaning.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/uapi/asm/Kbuild  |    2 +-
>  arch/avr32/include/uapi/asm/types.h |   13 -------------
>  2 files changed, 1 insertion(+), 14 deletions(-)
>  delete mode 100644 arch/avr32/include/uapi/asm/types.h
> 
> diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
> index 08d8a3d76ea8..1598223f0bfc 100644
> --- a/arch/avr32/include/uapi/asm/Kbuild
> +++ b/arch/avr32/include/uapi/asm/Kbuild
> @@ -19,7 +19,6 @@ header-y += stat.h
>  header-y += swab.h
>  header-y += termbits.h
>  header-y += termios.h
> -header-y += types.h
>  header-y += unistd.h
>  generic-y += bitsperlong.h
>  generic-y += errno.h
> @@ -34,3 +33,4 @@ generic-y += poll.h
>  generic-y += resource.h
>  generic-y += siginfo.h
>  generic-y += statfs.h
> +generic-y += types.h
> diff --git a/arch/avr32/include/uapi/asm/types.h b/arch/avr32/include/uapi/asm/types.h
> deleted file mode 100644
> index 7c986c4e99b5..000000000000
> --- a/arch/avr32/include/uapi/asm/types.h
> +++ /dev/null
> @@ -1,13 +0,0 @@
> -/*
> - * Copyright (C) 2004-2006 Atmel Corporation
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -#ifndef _UAPI__ASM_AVR32_TYPES_H
> -#define _UAPI__ASM_AVR32_TYPES_H
> -
> -#include <asm-generic/int-ll64.h>
> -
> -#endif /* _UAPI__ASM_AVR32_TYPES_H */
-- 
mvh
Hans-Christian Egtvedt
