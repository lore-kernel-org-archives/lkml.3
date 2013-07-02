Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3GBV2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:28:17 -0400
Received: from noserose.net ([66.220.18.76]:34231 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754900Ab3GBV2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:28:16 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 17:28:16 EDT
Date: Tue, 2 Jul 2013 14:28:11 -0700
Message-Id: <4de7fffc9247dfb7e9ef0adf29051d008d180a93.1372710099.git.ecashin@coraid.com>
In-Reply-To: <cover.1372710099.git.ecashin@coraid.com>
References: <cover.1372710099.git.ecashin@coraid.com>
From: ecashin@noserose.net
Subject: [PATCH 3/3] aoe: update internal version number to v83
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 2284f89..025c41d 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "81"
+#define VERSION "83"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.1

