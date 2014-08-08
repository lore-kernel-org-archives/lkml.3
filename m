Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbaHHUtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:49:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40750 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbaHHUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 048/259] drm/radeon/cik: fix typo in EOP packet
Date: Fri,  8 Aug 2014 13:37:51 -0700
Message-Id: <1407530482-4483-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b397207b7475afa9df2f94541f978100ff1ea47e upstream.

Volatile bit was in the wrong location.  This bit is
not used at the moment.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cikd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index e33f8d1..a62f51f 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1734,12 +1734,12 @@
 #define		EOP_TC_WB_ACTION_EN                     (1 << 15) /* L2 */
 #define		EOP_TCL1_ACTION_EN                      (1 << 16)
 #define		EOP_TC_ACTION_EN                        (1 << 17) /* L2 */
+#define		EOP_TCL2_VOLATILE                       (1 << 24)
 #define		EOP_CACHE_POLICY(x)                     ((x) << 25)
                 /* 0 - LRU
 		 * 1 - Stream
 		 * 2 - Bypass
 		 */
-#define		EOP_TCL2_VOLATILE                       (1 << 27)
 #define		DATA_SEL(x)                             ((x) << 29)
                 /* 0 - discard
 		 * 1 - send low 32bit data
-- 
1.9.1

