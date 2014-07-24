Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602AbaGXJsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934589AbaGXJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:12 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 075/128] drm/radeon/cik: fix typo in EOP packet
Date: Thu, 24 Jul 2014 10:45:24 +0100
Message-Id: <1406195177-8656-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b397207b7475afa9df2f94541f978100ff1ea47e upstream.

Volatile bit was in the wrong location.  This bit is
not used at the moment.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cikd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index 302d2b756e94..02846db501b5 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1123,12 +1123,12 @@
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

