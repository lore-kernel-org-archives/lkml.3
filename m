Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaGAKo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:44:58 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37581 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbaGAKo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:44:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for 3.16-rc4
Date: Tue,  1 Jul 2014 12:44:49 +0200
Message-Id: <1404211489-9848-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9a630d15f16dbe4fec7ef5a4bc570cd46774a968:

  Merge commit '33b458d276bb' into kvm-master (2014-06-30 16:45:40 +0200)

----------------------------------------------------------------

A bunch of one-liners (except the s390 one).

The two more serious bugs ("KVM: SVM: Fix CPL export via SS.DPL" and
"KVM: s390: add sie.h uapi header file to Kbuild and remove header
dependency") were introduced in the 3.16 merge window.

----------------------------------------------------------------
Deng-Cheng Zhu (1):
      MIPS: KVM: Fix memory leak on VCPU

Heiko Carstens (1):
      KVM: s390: add sie.h uapi header file to Kbuild and remove header dependency

Jan Kiszka (1):
      KVM: SVM: Fix CPL export via SS.DPL

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Paolo Bonzini (3):
      KVM: x86: preserve the high 32-bits of the PAT register
      Merge tag 'kvms390-20140626' of git://git.kernel.org/.../kvms390/linux into kvm-master
      Merge commit '33b458d276bb' into kvm-master

Xiaoming Gao (1):
      kvm: fix wrong address when writing Hyper-V tsc page

 arch/mips/kvm/kvm_mips.c          |  1 +
 arch/s390/include/uapi/asm/Kbuild |  1 +
 arch/s390/include/uapi/asm/sie.h  | 26 ++++++++++++--------------
 arch/x86/include/asm/kvm_host.h   |  4 ++--
 arch/x86/kvm/svm.c                |  1 +
 arch/x86/kvm/x86.c                |  2 +-
 6 files changed, 18 insertions(+), 17 deletions(-)
