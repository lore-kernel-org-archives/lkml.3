Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaIEVrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:47:22 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42477 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaIEVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:47:21 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL v2] KVM changes for 3.17-rc4
Date: Fri,  5 Sep 2014 23:47:13 +0200
Message-Id: <1409953633-1606-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 30d1e0e806e5b2fadc297ba78f2d7afd6ba309cf:

  virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1' after free it (2014-08-19 15:12:28 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 02a68d0503fa470abff8852e10b1890df5730a08:

  powerpc/kvm/cma: Fix panic introduces by signed shift operation (2014-09-03 10:34:07 +0200)

----------------------------------------------------------------
A smattering of bug fixes across most architectures.

----------------------------------------------------------------
Christian Borntraeger (4):
      KVM: s390: Fix user triggerable bug in dead code
      KVM: s390/mm: try a cow on read only pages for key ops
      KVM: s390/mm: Fix storage key corruption during swapping
      KVM: s390/mm: Fix guest storage key corruption in ptep_set_access_flags

Christoffer Dall (1):
      arm/arm64: KVM: Complete WFI/WFE instructions

Laurent Dufour (1):
      powerpc/kvm/cma: Fix panic introduces by signed shift operation

Paolo Bonzini (3):
      Merge tag 'kvm-s390-20140825' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge tag 'kvm-arm-for-v3.17-rc3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvm-s390-master-20140902' of git://git.kernel.org/.../kvms390/linux into kvm-master

Pranavkumar Sawargaonkar (1):
      ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

 arch/arm/kvm/handle_exit.c          |  2 ++
 arch/arm/kvm/init.S                 |  4 ++++
 arch/arm64/kvm/handle_exit.c        |  2 ++
 arch/arm64/kvm/hyp-init.S           |  4 ++++
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  4 ++--
 arch/s390/include/asm/pgtable.h     |  6 ++++--
 arch/s390/kvm/kvm-s390.c            | 13 -------------
 arch/s390/mm/pgtable.c              | 10 ++++++++++
 8 files changed, 28 insertions(+), 17 deletions(-)
