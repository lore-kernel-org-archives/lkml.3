Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaIVMCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:02:30 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:49826 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaIVMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:02:25 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] Final KVM changes for 3.17
Date: Mon, 22 Sep 2014 14:02:17 +0200
Message-Id: <1411387337-8275-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 02a68d0503fa470abff8852e10b1890df5730a08:

  powerpc/kvm/cma: Fix panic introduces by signed shift operation (2014-09-03 10:34:07 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 27fbe64bfa63cfb9da025975b59d96568caa2d53:

  KVM: correct null pid check in kvm_vcpu_yield_to() (2014-09-22 13:21:29 +0200)

----------------------------------------------------------------
Two very simple bugfixes, affecting all supported architectures.

----------------------------------------------------------------
Ard Biesheuvel (2):
      mm: export symbol dependencies of is_zero_pfn()
      KVM: check for !is_zero_pfn() in kvm_is_mmio_pfn()

Sam Bobroff (1):
      KVM: correct null pid check in kvm_vcpu_yield_to()

 arch/mips/mm/init.c | 1 +
 arch/s390/mm/init.c | 1 +
 mm/memory.c         | 2 ++
 virt/kvm/kvm_main.c | 4 ++--
 4 files changed, 6 insertions(+), 2 deletions(-)
