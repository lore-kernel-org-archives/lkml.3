Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3KFJIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:08:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab3KFJIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:08:12 -0500
Date: Wed, 6 Nov 2013 11:07:59 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: Delete prototype for non-existent function
 complete_pio
Message-ID: <20131106090759.GT7513@redhat.com>
References: <20131020142954.GA2962@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131020142954.GA2962@leaf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 20, 2013 at 03:29:57PM +0100, Josh Triplett wrote:
> complete_pio ceased to exist in commit
> 7972995b0c346de76fe260ce0fd6bcc8ffab724a ("KVM: x86 emulator: Move
> string pio emulation into emulator.c"), but the prototype remained.
> Remove its prototype.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Applied both, thanks. Sorry for the late reply.

> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c76ff74..00c5f44 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -926,7 +926,6 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
>  void kvm_enable_tdp(void);
>  void kvm_disable_tdp(void);
>  
> -int complete_pio(struct kvm_vcpu *vcpu);
>  bool kvm_check_iopl(struct kvm_vcpu *vcpu);
>  
>  static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
> -- 
> 1.8.4.rc3

--
			Gleb.
