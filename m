Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaDORL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:11:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44892 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaDORLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:19 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 5/6] powerpc/perf/hv-24x7: remove [static 4096], sparse chokes on it
Date: Tue, 15 Apr 2014 10:10:54 -0700
Message-Id: <1397581855-4585-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-0320-0000-0000-000003019341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 3e8f60a..95a67f8 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -170,7 +170,7 @@ static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
 			index);
 }
 
-static unsigned long h_get_24x7_catalog_page(char page[static 4096],
+static unsigned long h_get_24x7_catalog_page(char page[],
 					     u32 version, u32 index)
 {
 	return h_get_24x7_catalog_page_(virt_to_phys(page),
-- 
1.9.2

