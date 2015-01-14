Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbbANPYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:24:19 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43277 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbbANPYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:24:17 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.19-rc5
Date: Wed, 14 Jan 2015 16:24:09 +0100
Message-Id: <1421249049-13396-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit b1940cd21c0f4abdce101253e860feff547291b0:

  Linux 3.19-rc3 (2015-01-05 17:05:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 801f6772cecea6cfc7da61aa197716ab64db5f9e:

  arm64: KVM: Fix HCR setting for 32bit guests (2015-01-12 11:15:30 +0100)

----------------------------------------------------------------
Two bugfixes for arm64.  I will have another pull request next week,
but otherwise things are calm.

----------------------------------------------------------------
Marc Zyngier (2):
      arm64: KVM: Fix TLB invalidation by IPA/VMID
      arm64: KVM: Fix HCR setting for 32bit guests

 arch/arm64/include/asm/kvm_emulate.h | 2 ++
 arch/arm64/kvm/hyp.S                 | 1 +
 arch/arm64/kvm/reset.c               | 1 -
 3 files changed, 3 insertions(+), 1 deletion(-)
