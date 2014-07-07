Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaGHBA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:00:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaGGXyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.15 036/122] drm/radeon/cik: fix typo in EOP packet
Date: Mon,  7 Jul 2014 16:56:38 -0700
Message-Id: <20140707235735.327497046@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1751,12 +1751,12 @@
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


