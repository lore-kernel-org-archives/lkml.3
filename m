Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161759AbaKNR4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:56:51 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:49710 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161632AbaKNR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:56:49 -0500
Message-ID: <5466425D.1060100@cogentembedded.com>
Date: Fri, 14 Nov 2014 20:56:45 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, hpa@zytor.com
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 05/11] x86, mpx: add MPX to disaabled features
References: <20141114151816.F56A3072@viggo.jf.intel.com> <20141114151823.B358EAD2@viggo.jf.intel.com>
In-Reply-To: <20141114151823.B358EAD2@viggo.jf.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/14/2014 06:18 PM, Dave Hansen wrote:

> From: Dave Hansen <dave.hansen@linux.intel.com>

> This allows us to use cpu_feature_enabled(X86_FEATURE_MPX) as
> both a runtime and compile-time check.

> When CONFIG_X86_INTEL_MPX is disabled,
> cpu_feature_enabled(X86_FEATURE_MPX) will evaluate at
> compile-time to 0. If CONFIG_X86_INTEL_MPX=y, then the cpuid
> flag will be checked at runtime.

> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> ---

>   b/arch/x86/include/asm/disabled-features.h |    8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

> diff -puN arch/x86/include/asm/disabled-features.h~mpx-v11-add-MPX-to-disaabled-features arch/x86/include/asm/disabled-features.h
> --- a/arch/x86/include/asm/disabled-features.h~mpx-v11-add-MPX-to-disaabled-features	2014-11-14 07:06:22.297610243 -0800
> +++ b/arch/x86/include/asm/disabled-features.h	2014-11-14 07:06:22.300610378 -0800
[...]
> @@ -34,6 +40,6 @@
>   #define DISABLED_MASK6	0
>   #define DISABLED_MASK7	0
>   #define DISABLED_MASK8	0
> -#define DISABLED_MASK9	0
> +#define DISABLED_MASK9	(DISABLE_MPX)

    These parens are not really needed. Sorry to be a PITA and not saying this 
before.

[...]

WBR, Sergei

