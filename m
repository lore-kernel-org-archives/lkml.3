Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099Ab3BYSJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:09:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BYSJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:09:42 -0500
Date: Mon, 25 Feb 2013 20:09:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM ARM compilation fixes for the 3.9 merge window
Message-ID: <20130225180940.GA24877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git master

To receive the following KVM bug fixes. They fix ARM KVM compilation breakage
due to changes from kvm.git.


Marc Zyngier (3):
      ARM: KVM: fix kvm_arch_{prepare,commit}_memory_region
      ARM: KVM: Rename KVM_MEMORY_SLOTS -> KVM_USER_MEM_SLOTS
      ARM: KVM: fix compilation after removal of user_alloc from struct kvm_memory_slot

 arch/arm/include/asm/kvm_host.h |    2 +-
 arch/arm/kvm/arm.c              |    4 ++--
 arch/arm/kvm/mmu.c              |    5 -----
 3 files changed, 3 insertions(+), 8 deletions(-)

--
			Gleb.
