Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaGHAly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:41:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaGGXyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 34/94] drm/radeon/cik: fix typo in EOP packet
Date: Mon,  7 Jul 2014 16:57:24 -0700
Message-Id: <20140707235757.792301342@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b397207b7475afa9df2f94541f978100ff1ea47e upstream.

Volatile bit was in the wrong location.  This bit is
not used at the moment.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cikd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -1745,12 +1745,12 @@
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


