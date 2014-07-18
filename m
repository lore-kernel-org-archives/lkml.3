Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030607AbaGRNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:58 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17518 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030524AbaGRNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/170] drm/radeon/cik: fix typo in EOP packet
Date: Fri, 18 Jul 2014 14:11:31 +0200
Message-Id: <74c6eb737eb3509c7ec23b98b84c7ac4d9eceb14.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b397207b7475afa9df2f94541f978100ff1ea47e upstream.

Volatile bit was in the wrong location.  This bit is
not used at the moment.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cikd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index 70e88498a1fd..9c8ef204a3cb 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1695,12 +1695,12 @@
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
2.0.0

