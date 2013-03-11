Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3CKUCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:02:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45585 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab3CKUCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:02:32 -0400
Message-ID: <513E37CD.2030502@zytor.com>
Date: Mon, 11 Mar 2013 13:00:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Valentin Ilie <valentin.ilie@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Arch: x86: kernel: smpboot.c: Remove unused variable
References: <1363029780-2902-1-git-send-email-valentin.ilie@gmail.com>
In-Reply-To: <1363029780-2902-1-git-send-email-valentin.ilie@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 12:23 PM, Valentin Ilie wrote:
> Remove unused variable 'c'
> 
> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> ---
>  arch/x86/kernel/smpboot.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index a6ceaed..7bc998a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1367,7 +1367,6 @@ static inline void mwait_play_dead(void)
>  	unsigned int highest_subcstate = 0;
>  	int i;
>  	void *mwait_ptr;
> -	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
>  
>  	if (!this_cpu_has(X86_FEATURE_MWAIT))
>  		return;
> 

Already done.

	-hpa

