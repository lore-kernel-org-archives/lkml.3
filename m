Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3JCMqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:46:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab3JCMqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:46:49 -0400
Date: Thu, 3 Oct 2013 15:46:45 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/7] KVM: x86: small MMU cleanups
Message-ID: <20131003124645.GH17294@redhat.com>
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380725776-14948-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:56:09PM +0200, Paolo Bonzini wrote:
> A few small things (uninteresting callbacks or arguments, duplicate or
> dead code) that I noticed while reviewing Gleb's latest nVMX series.
> 
I applied 1-4 meanwhile.

> Paolo Bonzini (7):
>   KVM: mmu: remove uninteresting MMU "free" callbacks
>   KVM: mmu: remove uninteresting MMU "new_cr3" callbacks
>   KVM: mmu: unify destroy_kvm_mmu with kvm_mmu_unload
>   KVM: mmu: change useless int return types to void
>   KVM: mmu: remove argument to kvm_init_shadow_mmu and kvm_init_shadow_ept_mmu
>   KVM: mmu: remove ASSERT(vcpu)
>   KVM: mmu: replace assertions with MMU_WARN_ON
> 
>  arch/x86/include/asm/kvm_host.h |   7 +-
>  arch/x86/kvm/mmu.c              | 170 ++++++++++++----------------------------
>  arch/x86/kvm/mmu.h              |   5 +-
>  arch/x86/kvm/svm.c              |  10 +--
>  arch/x86/kvm/vmx.c              |   8 +-
>  arch/x86/kvm/x86.c              |   4 +-
>  6 files changed, 63 insertions(+), 141 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
