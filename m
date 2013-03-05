Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3CEWC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:02:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:39474 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab3CEWC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:02:27 -0500
Date: Tue, 5 Mar 2013 23:02:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Raphael S.Carvalho" <raphael.scarv@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arch/x86/smpboot.c: Fix GCC Warning (unused
 variable)!
In-Reply-To: <1362508625-7803-1-git-send-email-raphael.scarv@gmail.com>
Message-ID: <alpine.LFD.2.02.1303052257060.22263@ionos>
References: <1362508625-7803-1-git-send-email-raphael.scarv@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Mar 2013, Raphael S.Carvalho wrote:

> GCC complained about the unused variable c, thus I'm sending
> this patch in order to calm it down.
> I compiled the file and everything seems be ok!

What is your patch solving? How about removing the line completely?
And how about providing a changelog which makes sense ?

Thanks,

	tglx
 
> Signed-off-by: Raphael S.Carvalho <raphael.scarv@gmail.com>
> ---
>  arch/x86/kernel/smpboot.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a6ceaed..77a5616 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1367,7 +1367,7 @@ static inline void mwait_play_dead(void)
>  	unsigned int highest_subcstate = 0;
>  	int i;
>  	void *mwait_ptr;
> -	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
> +	__this_cpu_ptr(&cpu_info);
>  
>  	if (!this_cpu_has(X86_FEATURE_MWAIT))
>  		return;
> -- 
> 1.7.2.5
> 
> 
