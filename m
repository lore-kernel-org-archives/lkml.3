Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab3HITmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:42:20 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63537 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030814Ab3HITmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:42:18 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com
Subject: [GIT PULL] KVM/S390 fixes for 3.11-rc4
Date: Fri,  9 Aug 2013 21:42:05 +0200
Message-Id: <1376077325-19445-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 90db76e829479ef2ba1fed8f2552846015469831:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2013-07-20 20:11:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to e769ece3b129698d2b09811a6f6d304e4eaa8c29:

  KVM: s390: fix pfmf non-quiescing control handling (2013-07-29 09:02:30 +0200)

----------------------------------------------------------------
Two fixes for s390

----------------------------------------------------------------
Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie

Heiko Carstens (1):
      KVM: s390: fix pfmf non-quiescing control handling

 arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
 arch/s390/kvm/priv.c     |  4 ++--
 2 files changed, 16 insertions(+), 9 deletions(-)
