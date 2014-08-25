Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaHYL3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:29:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:27568 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbaHYL3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:29:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,397,1406617200"; 
   d="scan'208";a="472303462"
From: Tiejun Chen <tiejun.chen@intel.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86:kvm: fix one typo in comment
Date: Mon, 25 Aug 2014 19:26:17 +0800
Message-Id: <1408965977-32575-1-git-send-email-tiejun.chen@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/drity/dirty

Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9314678..09b9f05 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1180,7 +1180,7 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
  * Write-protect on the specified @sptep, @pt_protect indicates whether
  * spte write-protection is caused by protecting shadow page table.
  *
- * Note: write protection is difference between drity logging and spte
+ * Note: write protection is difference between dirty logging and spte
  * protection:
  * - for dirty logging, the spte can be set to writable at anytime if
  *   its dirty bitmap is properly set.
-- 
1.9.1

