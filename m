Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaBQJxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:53:14 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:34229 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaBQJxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:53:13 -0500
Date: Mon, 17 Feb 2014 10:52:32 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        tim.c.chen@linux.intel.com, liuj97@gmail.com,
        David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: avr32: include: asm: Kbuild: add generic "vga.h"
Message-ID: <20140217095232.GB20665@samfundet.no>
References: <5300A2A6.3010801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5300A2A6.3010801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 16 Feb 2014 19:36:06 +0800 or thereabout, Chen Gang wrote:
> Need add generic "vga.h", or can not pass building for allmodconfig,
> the related error:
> 
>     CC [M]  drivers/gpu/drm/drm_irq.o
>   In file included from include/linux/vgaarb.h:34,
>                    from drivers/gpu/drm/drm_irq.c:42:
>   include/video/vga.h:22:21: error: asm/vga.h: No such file or directory

Does this really makes sense for an architecture that only supports framebuffer?

I even recall doing something like this in the past, but the change probably
fell between chairs.

> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
> index 8b398ff..00a0f3c 100644
> --- a/arch/avr32/include/asm/Kbuild
> +++ b/arch/avr32/include/asm/Kbuild
> @@ -19,4 +19,5 @@ generic-y += scatterlist.h
>  generic-y += sections.h
>  generic-y += topology.h
>  generic-y += trace_clock.h
> +generic-y += vga.h
>  generic-y += xor.h
-- 
mvh
Hans-Christian Egtvedt
