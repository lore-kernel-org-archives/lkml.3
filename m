Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab3FSJJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:09:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48617 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934299Ab3FSJJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:41 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 0/7] KVM: MMU: update mmu documentation
Date: Wed, 19 Jun 2013 17:09:18 +0800
Message-Id: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-5564-0000-0000-0000086CE31C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Paolo pointed out that this is the time to update the documentation, this
patchest does it to let mmu.txt matches with the current mmu implementation

Xiao Guangrong (7):
  KVM: MMU: update the documentation for reverse mapping of parent_pte
  KVM: MMU: document clear_spte_count
  KVM: MMU: document write_flooding_count
  KVM: MMU: document mmio page fault
  KVM: MMU: document fast page fault in
  KVM: MMU: document fast invalidate all pages
  KVM: MMU: document fast invalidate all mmio sptes

 Documentation/virtual/kvm/mmu.txt | 86 +++++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/kvm_host.h   | 15 +++++++
 arch/x86/kvm/mmu.c                |  7 ++--
 3 files changed, 97 insertions(+), 11 deletions(-)

-- 
1.8.1.4

