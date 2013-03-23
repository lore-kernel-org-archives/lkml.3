Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CWAVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 20:21:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50884 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab3CWAVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 20:21:35 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1363987742.8972.55.camel@schen9-DESK>
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987742.8972.55.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/11] Added macro to check for AVX2 feature.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 22 Mar 2013 17:21:19 -0700
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S.Miller" <davem@davemloft.net>
CC: Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Message-ID: <09e94963-5146-4c1b-ab76-64ac73d660ab@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really, really hate these macros... Not sure they are worth the extra noise.

Tim Chen <tim.c.chen@linux.intel.com> wrote:

>Macro to facilitate checking the availability of the AVX2 feature.
>
>Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>---
> arch/x86/include/asm/cpufeature.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/include/asm/cpufeature.h
>b/arch/x86/include/asm/cpufeature.h
>index 2d9075e..db98ec7 100644
>--- a/arch/x86/include/asm/cpufeature.h
>+++ b/arch/x86/include/asm/cpufeature.h
>@@ -313,6 +313,7 @@ extern const char * const x86_power_flags[32];
> #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
> #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
> #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
>+#define cpu_has_avx2		boot_cpu_has(X86_FEATURE_AVX2)
> 
> #ifdef CONFIG_X86_64
> 

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
