Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaDORL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:11:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44886 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbaDORLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 3/6] powerpc/perf/hv-gpci: make device attr static
Date: Tue, 15 Apr 2014 10:10:52 -0700
Message-Id: <1397581855-4585-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-0320-0000-0000-000003019331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-gpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index 8fee1dc..c9d399a 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -78,7 +78,7 @@ static ssize_t kernel_version_show(struct device *dev,
 	return sprintf(page, "0x%x\n", COUNTER_INFO_VERSION_CURRENT);
 }
 
-DEVICE_ATTR_RO(kernel_version);
+static DEVICE_ATTR_RO(kernel_version);
 HV_CAPS_ATTR(version, "0x%x\n");
 HV_CAPS_ATTR(ga, "%d\n");
 HV_CAPS_ATTR(expanded, "%d\n");
-- 
1.9.2

