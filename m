Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaBNLOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:14:19 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:62124 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaBNLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:14:17 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL] KVM fixes for -rc3
Date: Fri, 14 Feb 2014 12:14:04 +0100
Message-Id: <1392376444-9012-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b73117c49364551ff789db7c424a115ac5b77850:

  Merge branch 'kvm-ppc-next' of git://github.com/agraf/linux-2.6 into kvm-queue (2014-01-29 18:29:01 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 2a2f3e269c75edf916de5967079069aeb6a601cb:

  arm64: KVM: Add VGIC device control for arm64 (2014-02-14 11:09:49 +0100)

Thanks,

Paolo

----------------------------------------------------------------
A small error handling problem and a compile breakage for ARM64.

----------------------------------------------------------------
Christoffer Dall (1):
      arm64: KVM: Add VGIC device control for arm64

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

 arch/arm64/include/uapi/asm/kvm.h | 9 +++++++++
 virt/kvm/arm/vgic.c               | 1 +
 virt/kvm/coalesced_mmio.c         | 8 ++------
 3 files changed, 12 insertions(+), 6 deletions(-)
