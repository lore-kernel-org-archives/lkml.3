Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaEIH5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:57:34 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44559 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbaEIH5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:57:32 -0400
Date: Fri, 9 May 2014 09:57:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andres Freund <andres@anarazel.de>
Cc: Borislav Petkov <bp@suse.de>, x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID
 macro
Message-ID: <20140509075730.GB16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
 <1399598957-7011-3-git-send-email-andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1399598957-7011-3-git-send-email-andres@anarazel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 03:29:17AM +0200, Andres Freund wrote:
> The spuriously added semicolon didn't have any effect because the
> macro isn't currently in use.
> 
> c0a639ad0bc6b178b46996bd1f821a04643e2bde
> 
> Signed-off-by: Andres Freund <andres@anarazel.de>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/uapi/asm/msr-index.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index c827ace..fcf2b3a 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -384,7 +384,7 @@
>  #define MSR_IA32_MISC_ENABLE_MWAIT_BIT			18
>  #define MSR_IA32_MISC_ENABLE_MWAIT			(1ULL << MSR_IA32_MISC_ENABLE_MWAIT_BIT)
>  #define MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT		22
> -#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT);
> +#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT)
>  #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT		23
>  #define MSR_IA32_MISC_ENABLE_XTPR_DISABLE		(1ULL << MSR_IA32_MISC_ENABLE_XTPR_DISABLE_BIT)
>  #define MSR_IA32_MISC_ENABLE_XD_DISABLE_BIT		34

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
