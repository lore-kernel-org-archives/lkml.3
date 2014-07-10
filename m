Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaGJWJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:09:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57460 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaGJVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:01 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 33/83] hsa/radeon: Fix coding style in cik_int.h
Date: Fri, 11 Jul 2014 00:53:49 +0300
Message-Id: <1405029279-6894-5-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_int.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_int.h b/drivers/gpu/hsa/radeon/cik_int.h
index e98551d..350f0c2 100644
--- a/drivers/gpu/hsa/radeon/cik_int.h
+++ b/drivers/gpu/hsa/radeon/cik_int.h
@@ -26,20 +26,20 @@
 #include <linux/types.h>
 
 struct cik_ih_ring_entry {
-	uint32_t source_id	: 8;
-	uint32_t reserved1	: 8;
-	uint32_t reserved2	: 16;
+	uint32_t source_id:8;
+	uint32_t reserved1:8;
+	uint32_t reserved2:16;
 
-	uint32_t data		: 28;
-	uint32_t reserved3	: 4;
+	uint32_t data:28;
+	uint32_t reserved3:4;
 
 	/* pipeid, meid and unused3 are officially called RINGID,
 	 * but for our purposes, they always decode into pipe and ME. */
-	uint32_t pipeid		: 2;
-	uint32_t meid		: 2;
-	uint32_t reserved4	: 4;
-	uint32_t vmid		: 8;
-	uint32_t pasid		: 16;
+	uint32_t pipeid:2;
+	uint32_t meid:2;
+	uint32_t reserved4:4;
+	uint32_t vmid:8;
+	uint32_t pasid:16;
 
 	uint32_t reserved5;
 };
-- 
1.9.1

