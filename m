Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LLVtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:49:43 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:32790 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LLVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:49:41 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: kvm@vger.kernel.org, gleb@kernel.org
Subject: [GIT PULL] KVM fixes for 3.13-rc4
Date: Thu, 12 Dec 2013 22:49:32 +0100
Message-Id: <1386884972-16292-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 2e7babfa892a55588467ef03b545002e32f31528:

  Merge branch 'for_linus' of git://cavan.codon.org.uk/platform-drivers-x86 (2013-11-22 16:47:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 17d68b763f09a9ce824ae23eb62c9efc57b69271:

  KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376) (2013-12-12 22:46:18 +0100)

----------------------------------------------------------------
Four security fixes for KVM on x86.  Thanks to Andrew Honig and Lars Bull
from Google for reporting them.

----------------------------------------------------------------
Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

 arch/x86/kvm/lapic.c | 35 +++++++++++++++++++++--------------
 arch/x86/kvm/lapic.h |  4 ++--
 arch/x86/kvm/x86.c   | 40 +---------------------------------------
 virt/kvm/kvm_main.c  |  3 +++
 4 files changed, 27 insertions(+), 55 deletions(-)
