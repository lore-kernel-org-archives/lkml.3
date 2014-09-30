Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaI3Kk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:40:27 -0400
Received: from ozlabs.org ([103.22.144.67]:55053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbaI3Kfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:39 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 05/17] powerpc/mm: Export mmu_kernel_ssize and mmu_linear_psize
Date: Tue, 30 Sep 2014 20:34:54 +1000
Message-Id: <1412073306-13812-6-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/mm/hash_utils_64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 5c0738d..bbdb054 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -98,6 +98,7 @@ unsigned long htab_size_bytes;
 unsigned long htab_hash_mask;
 EXPORT_SYMBOL_GPL(htab_hash_mask);
 int mmu_linear_psize = MMU_PAGE_4K;
+EXPORT_SYMBOL_GPL(mmu_linear_psize);
 int mmu_virtual_psize = MMU_PAGE_4K;
 int mmu_vmalloc_psize = MMU_PAGE_4K;
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
@@ -105,6 +106,7 @@ int mmu_vmemmap_psize = MMU_PAGE_4K;
 #endif
 int mmu_io_psize = MMU_PAGE_4K;
 int mmu_kernel_ssize = MMU_SEGSIZE_256M;
+EXPORT_SYMBOL_GPL(mmu_kernel_ssize);
 int mmu_highuser_ssize = MMU_SEGSIZE_256M;
 u16 mmu_slb_size = 64;
 EXPORT_SYMBOL_GPL(mmu_slb_size);
-- 
1.9.1

