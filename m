Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab3G3S4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:56:17 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:65257 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3G3S4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:56:13 -0400
Date: Tue, 30 Jul 2013 20:56:09 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, ffainelli@freebox.fr,
        bigeasy@linutronix.de, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, yongjun_wei@trendmicro.com.cn,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] x86: ce4100: remove duplicated include from
 ce4100.c
Message-ID: <20130730185609.GB21687@gmail.com>
References: <CAPgLHd_SnM4M-OZ5hX-vRpvjcm4=i-LiNgTTvwQmHhmOdsaPeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_SnM4M-OZ5hX-vRpvjcm4=i-LiNgTTvwQmHhmOdsaPeg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  arch/x86/platform/ce4100/ce4100.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
> index 8244f5e..d62e74d 100644
> --- a/arch/x86/platform/ce4100/ce4100.c
> +++ b/arch/x86/platform/ce4100/ce4100.c
> @@ -15,7 +15,6 @@
>  #include <linux/reboot.h>
>  #include <linux/serial_reg.h>
>  #include <linux/serial_8250.h>
> -#include <linux/reboot.h>
>  
>  #include <asm/ce4100.h>
>  #include <asm/prom.h>

Hm, while at it, this file could need more cleanups:

 - nonstandard comments
 - various checkpatch complaints that seem legit
 - col80 limits were 'solved' using ugly linebreaks

Thanks,

	Ingo
