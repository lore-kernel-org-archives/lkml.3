Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaE0WIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:08:49 -0400
Received: from ozlabs.org ([103.22.144.67]:34933 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaE0WIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:08:48 -0400
Date: Wed, 28 May 2014 08:08:38 +1000
From: Paul Mackerras <paulus@samba.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] KVM fixes for 3.15-rc6
Message-ID: <20140527220838.GA32311@iris.ozlabs.ibm.com>
References: <1400254112-4662-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400254112-4662-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 05:28:32PM +0200, Paolo Bonzini wrote:
> Linus,
> 
> The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:
> 
>   Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> for you to fetch changes up to a4e91d04b86504f145cc5f766c2609357a68b186:

Linus seems not to have done this pull yet - Paolo, maybe you should
resend the request and cc Linus this time?

> 
>   Merge tag 'kvm-s390-for-3.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-master (2014-05-15 14:46:57 +0200)
> 
> ----------------------------------------------------------------
> 
> Small fixes for x86, slightly larger fixes for PPC, and a forgotten s390 patch.
> The PPC fixes are important because they fix breakage that is new in 3.15.
> 
> ----------------------------------------------------------------
> Alexander Graf (2):
>       KVM: PPC: Book3S: ifdef on CONFIG_KVM_BOOK3S_32_HANDLER for 32bit
>       KVM guest: Make pv trampoline code executable
> 
> Cornelia Huck (1):
>       KVM: s390: announce irqfd capability
> 
> Marcelo Tosatti (1):
>       KVM: x86: disable master clock if TSC is reset during suspend
> 
> Paolo Bonzini (3):
>       KVM: vmx: disable APIC virtualization in nested guests
>       Merge tag 'signed-for-3.15' of git://github.com/agraf/linux-2.6 into kvm-master
>       Merge tag 'kvm-s390-for-3.15-1' of git://git.kernel.org/.../kvms390/linux into kvm-master
> 
> Paul Mackerras (1):
>       KVM: PPC: Book3S HV: Add missing code for transaction reclaim on guest exit
> 
> pingfank@linux.vnet.ibm.com (1):
>       KVM: PPC: Book3S: HV: make _PAGE_NUMA take effect
> 
>  Documentation/virtual/kvm/api.txt       |   2 +-
>  arch/powerpc/include/asm/sections.h     |  11 ++++
>  arch/powerpc/kernel/kvm.c               |   2 +-
>  arch/powerpc/kvm/book3s.c               |   6 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c     |   2 +-
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 104 ++++++++++++++++++++++++++++++++
>  arch/powerpc/kvm/book3s_pr.c            |   6 +-
>  arch/powerpc/mm/hash_utils_64.c         |   4 ++
>  arch/s390/kvm/kvm-s390.c                |   1 +
>  arch/x86/kvm/vmx.c                      |   7 ++-
>  arch/x86/kvm/x86.c                      |   6 +-
>  11 files changed, 139 insertions(+), 12 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
