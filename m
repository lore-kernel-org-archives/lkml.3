Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934907Ab3FSRLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:11:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38609 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab3FSRL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:11:28 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 3.10-rc7
Date: Wed, 19 Jun 2013 19:11:18 +0200
Message-Id: <1371661878-6221-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

the following changes since commit 77293e215edef7871a39de4b326f777bc39278ca:

  Merge branch 'fixes-3.10' of git://git.infradead.org/users/willy/linux-nvme (2013-06-11 23:07:21 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 07868fc6aaf57847b0f3a3d53086b7556eb83f4a:

  x86: kvmclock: zero initialize pvclock shared memory area (2013-06-19 12:25:28 +0200)

Three one-line fixes for my first pull request; one for x86 host, one
for x86 guest, one for PPC.  Tried using signed tags.

----------------------------------------------------------------
KVM fixes for 3.10-rc6

----------------------------------------------------------------
Igor Mammedov (1):
      x86: kvmclock: zero initialize pvclock shared memory area

Scott Wood (1):
      kvm/ppc/booke: Delay kvmppc_lazy_ee_enable

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

 arch/powerpc/kvm/booke.c   | 3 ++-
 arch/x86/kernel/kvmclock.c | 1 +
 arch/x86/kvm/x86.c         | 5 ++---
 3 files changed, 5 insertions(+), 4 deletions(-)
-- 
1.8.1.4
