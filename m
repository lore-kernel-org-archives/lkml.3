Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3KXEXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 23:23:33 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54177 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3KXEX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 23:23:28 -0500
Message-ID: <52917F41.8060302@gmail.com>
Date: Sun, 24 Nov 2013 12:23:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: hexagon: include: asm: add "vga.h" in Kbuild
References: <528AF461.4020502@gmail.com>
In-Reply-To: <528AF461.4020502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check it when you have time, thanks.

I changed my mail address -- I have to leave original company, so at
present, I need be as a volunteer to Public Open Source (just like
another quite a few volunteers).

Within this month, I still want to let hexagon pass allmodconfig, hope
we can continue (in the future, at least, as a volunteer, I still plan
to provide 1-3 patches per month to upstream kernel).


BTW: in fact, my original contributions to upstream kernel have given me
much help for finding/changing 'jobs' (but sorry, I can not be sure
whether I can still mainly focus on upstream kernel, next).


:-)

Thanks.

On 11/19/2013 01:17 PM, Chen Gang wrote:
> Need include generic "vga.h", or can not pass compiling with
> allmodconfig, the related error:
> 
>     CC [M]  drivers/gpu/drm/drm_irq.o
>   In file included from include/linux/vgaarb.h:34:0,
>                    from drivers/gpu/drm/drm_irq.c:42:
>   include/video/vga.h:22:21: fatal error: asm/vga.h: No such file or directory
> 
> Also move "preempt.h" upper to match sort order.
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/include/asm/Kbuild |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
> index 67c3450..424e28e 100644
> --- a/arch/hexagon/include/asm/Kbuild
> +++ b/arch/hexagon/include/asm/Kbuild
> @@ -31,6 +31,7 @@ generic-y += pci.h
>  generic-y += percpu.h
>  generic-y += poll.h
>  generic-y += posix_types.h
> +generic-y += preempt.h
>  generic-y += resource.h
>  generic-y += rwsem.h
>  generic-y += scatterlist.h
> @@ -52,5 +53,5 @@ generic-y += trace_clock.h
>  generic-y += types.h
>  generic-y += ucontext.h
>  generic-y += unaligned.h
> +generic-y += vga.h
>  generic-y += xor.h
> -generic-y += preempt.h
> 


-- 
Chen Gang
