Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3KOQxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 11:53:15 -0500
Received: from ra.se.axis.com ([195.60.68.13]:57567 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab3KOQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 11:53:03 -0500
Date: Fri, 15 Nov 2013 17:52:59 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 02/17] cris: Use Kbuild logic to include
 <asm-generic/sections.h>
Message-ID: <20131115165259.GO17608@axis.com>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>
 <1384285347-13506-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384285347-13506-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 08:42:12PM +0100, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> ---
>  arch/cris/include/asm/Kbuild     |    1 +
>  arch/cris/include/asm/sections.h |    7 -------
>  2 files changed, 1 insertion(+), 7 deletions(-)
>  delete mode 100644 arch/cris/include/asm/sections.h
> 
> diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
> index b06caf649a95..44e7d0dbcf32 100644
> --- a/arch/cris/include/asm/Kbuild
> +++ b/arch/cris/include/asm/Kbuild
> @@ -8,6 +8,7 @@ generic-y += exec.h
>  generic-y += kvm_para.h
>  generic-y += linkage.h
>  generic-y += module.h
> +generic-y += sections.h
>  generic-y += trace_clock.h
>  generic-y += vga.h
>  generic-y += xor.h
> diff --git a/arch/cris/include/asm/sections.h b/arch/cris/include/asm/sections.h
> deleted file mode 100644
> index 2c998ce8967b..000000000000
> --- a/arch/cris/include/asm/sections.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _CRIS_SECTIONS_H
> -#define _CRIS_SECTIONS_H
> -
> -/* nothing to see, move along */
> -#include <asm-generic/sections.h>
> -
> -#endif
> -- 
> 1.7.9.5

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
