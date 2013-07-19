Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760584Ab3GSQhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:37:09 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:50553 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3GSQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:37:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 3.11-rc2
Date: Fri, 19 Jul 2013 18:36:55 +0200
Message-Id: <1374251815-9050-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1c118b8226922d225a7df4127926ed2a2d73baaf:

  KVM: MMU: avoid fast page fault fixing mmio page fault (2013-07-18 12:26:57 +0200)

This single patch fixes a regression caused by one of the optimizations
introduced in 3.11, which is generally visible only on AMD processors.

----------------------------------------------------------------
Fix for AMD processors.

----------------------------------------------------------------
Xiao Guangrong (1):
      KVM: MMU: avoid fast page fault fixing mmio page fault

 arch/x86/kvm/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)
