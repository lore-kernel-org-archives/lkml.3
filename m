Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3JJKCJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:02:09 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52983 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3JJKCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:02:07 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for 3.12-rc5
Date: Thu, 10 Oct 2013 12:01:58 +0200
Message-Id: <1381399318-3130-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 6d15ee492809d38bd62237b6d0f6a81d4dd12d15:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-10-03 08:56:41 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 40fde70d0df993d1a652d6cc69f8b4e967656170:

  kvm: ppc: booke: check range page invalidation progress on page setup (2013-10-10 11:40:08 +0200)

----------------------------------------------------------------
Fixes for 3.12-rc5.  Two old PPC bugs and one new (3.12-rc2) x86 bug.

----------------------------------------------------------------
Bharat Bhushan (1):
      kvm: ppc: booke: check range page invalidation progress on page setup

Gleb Natapov (1):
      KVM: nVMX: fix shadow on EPT

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Fix typo in saving DSCR

 arch/powerpc/kvm/book3s_hv_rmhandlers.S |  2 +-
 arch/powerpc/kvm/e500_mmu_host.c        | 18 +++++++++++++++++-
 arch/x86/kvm/vmx.c                      | 24 ++++++++++++------------
 3 files changed, 30 insertions(+), 14 deletions(-)
