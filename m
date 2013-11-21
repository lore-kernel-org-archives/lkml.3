Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3KUNfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:35:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab3KUNfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:35:44 -0500
Date: Thu, 21 Nov 2013 15:35:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [GIT PULL] KVM fixes for 3.13
Message-ID: <20131121133540.GN2108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull KVM fixes below.

The following changes since commit f080480488028bcc25357f85e8ae54ccc3bb7173:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2013-11-15 13:51:36 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/virt/kvm/kvm.git next

for you to fetch changes up to 8a3caa6d74597c2a083f7c87f866891a0b12540b:

  KVM: kvm_clear_guest_page(): fix empty_zero_page usage (2013-11-21 11:19:32 +0200)

----------------------------------------------------------------
Christoffer Dall (1):
      arm/arm64: KVM: Fix hyp mappings of vmalloc regions

Gleb Natapov (1):
      Merge tag 'kvm-arm-fixes-3.13-1' of git://git.linaro.org/people/cdall/linux-kvm-arm into next

Heiko Carstens (1):
      KVM: kvm_clear_guest_page(): fix empty_zero_page usage

Sasha Levin (1):
      kvm: mmu: delay mmu audit activation

 arch/arm/kvm/mmu.c       | 34 ++++++++++++++++++++++++++++------
 arch/x86/kvm/mmu_audit.c |  2 +-
 virt/kvm/kvm_main.c      |  5 +++--
 3 files changed, 32 insertions(+), 9 deletions(-)
--
			Gleb.
