Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162715Ab3LFNdr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:33:47 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58498 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161713Ab3LFNdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:33:44 -0500
Date: Fri, 6 Dec 2013 14:33:39 +0100
From: Borislav Petkov <bp@alien8.de>
To: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>,
        Liu Jinsong <jinsong.liu@intel.com>
Subject: Re: [PATCH 2/3] X86, mpx: Intel MPX definition
Message-ID: <20131206133339.GC6694@pd.tnic>
References: <1386355976-11732-1-git-send-email-qiaowei.ren@intel.com>
 <1386355976-11732-2-git-send-email-qiaowei.ren@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386355976-11732-2-git-send-email-qiaowei.ren@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 07, 2013 at 02:52:55AM +0800, Qiaowei Ren wrote:
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> Signed-off-by: Xudong Hao <xudong.hao@intel.com>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

This patch should probably be merged with the next one...

> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index d3f5c63..6c2738d 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -216,6 +216,7 @@
>  #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
>  #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
>  #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
> +#define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
>  #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
>  #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
>  #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
> @@ -330,6 +331,7 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_perfctr_l2	boot_cpu_has(X86_FEATURE_PERFCTR_L2)
>  #define cpu_has_cx8		boot_cpu_has(X86_FEATURE_CX8)
>  #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
> +#define cpu_has_mpx		boot_cpu_has(X86_FEATURE_MPX)

... and we're trying to not have more of those macros so people should be simply
using boot_cpu_has(X86_FEATURE_YYY).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
