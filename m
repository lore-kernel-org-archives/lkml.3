Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3FKLsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3FKLsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:48:20 -0400
Date: Tue, 11 Jun 2013 14:48:16 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.10-rc5
Message-ID: <20130611114816.GA30505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git fixes

To receive the following KVM bug fixes. There is one more fix for MIPS
KVM ABI here, MIPS and PPC build breakage fixes and a couple of PPC bug fixes.


David Daney (2):
      kvm: Add definition of KVM_REG_MIPS
      mips/kvm: Use KVM_REG_MIPS and proper size indicators for *_ONE_REG

James Hogan (1):
      KVM: add kvm_para_available to asm-generic/kvm_para.h

Mihai Caraman (1):
      kvm/ppc/booke64: Fix AltiVec interrupt numbers and build breakage

Scott Wood (3):
      kvm/ppc/booke64: Disable e6500 support
      kvm/ppc/booke: Hold srcu lock when calling gfn functions
      kvm/ppc/booke64: Fix lazy ee handling in kvmppc_handle_exit()

 arch/mips/include/uapi/asm/kvm.h   |   81 +++++++++++++++++------------------
 arch/mips/kvm/kvm_mips.c           |   83 +++++++++++++++++++++++-------------
 arch/powerpc/include/asm/kvm_asm.h |   16 ++++---
 arch/powerpc/kvm/44x_tlb.c         |    5 +++
 arch/powerpc/kvm/booke.c           |   18 ++++++++
 arch/powerpc/kvm/e500_mmu.c        |    5 +++
 arch/powerpc/kvm/e500mc.c          |    2 -
 include/asm-generic/kvm_para.h     |    5 +++
 include/uapi/linux/kvm.h           |    1 +
 9 files changed, 137 insertions(+), 79 deletions(-)

--
			Gleb.
