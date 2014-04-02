Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430AbaDBWMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:12:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38025 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414AbaDBWLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:11:04 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>, cody+local@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/2] fixup: "powerpc/perf: Add support for the hv 24x7 interface"
Date: Wed,  2 Apr 2014 15:10:53 -0700
Message-Id: <1396476654-20623-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1396476654-20623-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040222-9332-0000-0000-00000052E9AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the "not enabled" message less awful.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 297c9105..3246ea2 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -491,7 +491,7 @@ static int hv_24x7_init(void)
 
 	hret = hv_perf_caps_get(&caps);
 	if (hret) {
-		pr_info("could not obtain capabilities, error 0x%80lx, not enabling\n",
+		pr_info("could not obtain capabilities, not enabling (%ld)\n",
 				hret);
 		return -ENODEV;
 	}
-- 
1.9.1

