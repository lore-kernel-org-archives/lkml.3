Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaIQOLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:11:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQOLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:11:04 -0400
Date: Wed, 17 Sep 2014 16:10:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: bp@alien8.de, mingo@kernel.org, nadav.amit@gmail.com, pbonzini@redhat.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
Message-ID: <20140917141043.GM2840@worktop.localdomain>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
 <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 03:54:12PM +0300, Nadav Amit wrote:
> Adding structs that reflect various cpuid fields in x86 architecture. Structs
> were added only for functions that are not pure bitmaps.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 163 insertions(+)
>  create mode 100644 arch/x86/include/asm/cpuid_def.h
> 
> diff --git a/arch/x86/include/asm/cpuid_def.h b/arch/x86/include/asm/cpuid_def.h
> new file mode 100644
> index 0000000..0cf43ba
> --- /dev/null
> +++ b/arch/x86/include/asm/cpuid_def.h
> @@ -0,0 +1,163 @@
> +#ifndef ARCH_X86_KVM_CPUID_DEF_H
> +#define ARCH_X86_KVM_CPUID_DEF_H

Stale name? Its not exclusively used for KVM and the header name itself
doesn't include KVM either.
