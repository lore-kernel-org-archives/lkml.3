Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030678AbaDBWLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:11:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46895 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932763AbaDBWLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:11:03 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>, cody+local@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/2] fixup: "powerpc/perf: Add support for the hv gpci (get performance counter info) interface"
Date: Wed,  2 Apr 2014 15:10:54 -0700
Message-Id: <1396476654-20623-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040222-7182-0000-0000-00000A340122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the "not enabled" message less awful.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-gpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 278ba7b..f6c471d 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -279,7 +279,7 @@ static int hv_gpci_init(void)
 
 	hret = hv_perf_caps_get(&caps);
 	if (hret) {
-		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
+		pr_info("could not obtain capabilities, not enabling (%ld)\n",
 				hret);
 		return -ENODEV;
 	}
-- 
1.9.1

