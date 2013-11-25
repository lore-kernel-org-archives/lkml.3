Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3KYJD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:03:27 -0500
Received: from ra.se.axis.com ([195.60.68.13]:52145 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3KYJDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:03:17 -0500
Date: Mon, 25 Nov 2013 10:03:13 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 15/24] cris: Use Kbuild logic to provide <asm/types.h>
Message-ID: <20131125090313.GU15831@axis.com>
References: <1385369734-24893-1-git-send-email-geert@linux-m68k.org>
 <1385369734-24893-16-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385369734-24893-16-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 09:55:25AM +0100, Geert Uytterhoeven wrote:
> The extra definition for BITS_PER_LONG is also indirectly provided
> by <asm-generic/types.h>, via <asm-generic/int-ll64.h> and
> <asm/bitsperlong.h>
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> ---
>  arch/cris/include/asm/Kbuild  |    1 +
>  arch/cris/include/asm/types.h |   12 ------------
>  2 files changed, 1 insertion(+), 12 deletions(-)
>  delete mode 100644 arch/cris/include/asm/types.h
> 
> diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
> index 44e7d0dbcf32..2433df443890 100644
> --- a/arch/cris/include/asm/Kbuild
> +++ b/arch/cris/include/asm/Kbuild
> @@ -13,3 +13,4 @@ generic-y += trace_clock.h
>  generic-y += vga.h
>  generic-y += xor.h
>  generic-y += preempt.h
> +generic-y += types.h
> diff --git a/arch/cris/include/asm/types.h b/arch/cris/include/asm/types.h
> deleted file mode 100644
> index a3cac7757c7f..000000000000
> --- a/arch/cris/include/asm/types.h
> +++ /dev/null
> @@ -1,12 +0,0 @@
> -#ifndef _ETRAX_TYPES_H
> -#define _ETRAX_TYPES_H
> -
> -#include <uapi/asm/types.h>
> -
> -/*
> - * These aren't exported outside the kernel to avoid name space clashes
> - */
> -
> -#define BITS_PER_LONG 32
> -
> -#endif
> -- 
> 1.7.9.5

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
