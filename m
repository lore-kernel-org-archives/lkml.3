Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3ENQ16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:27:58 -0400
Received: from ra.se.axis.com ([195.60.68.13]:54509 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3ENQ15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:27:57 -0400
Date: Tue, 14 May 2013 18:27:49 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>, Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 2/5] cris: Wire up asm-generic/xor.h
Message-ID: <20130514162749.GP8853@axis.com>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
 <1368516726-8035-2-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368516726-8035-2-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 09:32:03AM +0200, Geert Uytterhoeven wrote:
> crypto/xor.c:25:21: fatal error: asm/xor.h: No such file or directory
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mikael Starvik <starvik@axis.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Cc: linux-cris-kernel@axis.com
> ---
>  arch/cris/include/asm/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
> index 1e7dfad..0dd4b88 100644
> --- a/arch/cris/include/asm/Kbuild
> +++ b/arch/cris/include/asm/Kbuild
> @@ -9,3 +9,4 @@ generic-y += kvm_para.h
>  generic-y += linkage.h
>  generic-y += module.h
>  generic-y += trace_clock.h
> +generic-y += xor.h
> -- 
> 1.7.0.4

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
