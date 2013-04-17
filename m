Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3DQA2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3DQA2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:28:45 -0400
Date: Tue, 16 Apr 2013 21:28:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.9-rc7
Message-ID: <20130417002804.GA18580@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: ~/inbox/sent-mutt-Aug-2012
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following PPC and ARM KVM fixes

Marc Zyngier (2):
      ARM: KVM: fix KVM_CAP_ARM_SET_DEVICE_ADDR reporting
      ARM: KVM: fix L_PTE_S2_RDWR to actually be Read/Write

Marcelo Tosatti (1):
      Merge branch 'kvm-arm-fixes-3.9' of git://github.com/columbia/linux-kvm-arm

Scott Wood (4):
      kvm/powerpc/e500mc: fix tlb invalidation on cpu migration
      kvm/ppc/e500: h2g_tlb1_rmap: esel 0 is valid
      kvm/ppc/e500: g2h_tlb1_map: clear old bit before setting new bit
      kvm/ppc/e500: eliminate tlb_refs

 arch/arm/include/asm/pgtable-3level.h |    2 
 arch/arm/kvm/arm.c                    |    1 
 arch/powerpc/kvm/e500.h               |   24 +++------
 arch/powerpc/kvm/e500_mmu_host.c      |   86 +++++++++++-----------------------
 arch/powerpc/kvm/e500mc.c             |    7 ++
 5 files changed, 44 insertions(+), 76 deletions(-)
