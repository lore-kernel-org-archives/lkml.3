Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbaCLRia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:38:30 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50577 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaCLRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:38:29 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.14-rc7
Date: Wed, 12 Mar 2014 18:38:16 +0100
Message-Id: <1394645896-5036-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 1b385cbdd74aa803e966e01e5fe49490d6044e30:

  kvm, vmx: Really fix lazy FPU on nested guest (2014-02-27 22:54:11 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 596f3142d2b7be307a1652d59e7b93adab918437:

  KVM: SVM: fix cr8 intercept window (2014-03-12 18:21:10 +0100)

----------------------------------------------------------------
The ARM patch fixes a build breakage with randconfig.  The x86 one
fixes Windows guests on AMD processors.

----------------------------------------------------------------
Marc Zyngier (1):
      ARM: KVM: fix non-VGIC compilation

Radim Krčmář (1):
      KVM: SVM: fix cr8 intercept window

 arch/x86/kvm/svm.c     | 6 +++---
 include/kvm/arm_vgic.h | 5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)
