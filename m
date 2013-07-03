Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3GCBwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 21:52:04 -0400
Received: from dupo.coraid.com ([208.71.232.133]:50347 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143Ab3GCBwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 21:52:02 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 21:52:02 EDT
Message-Id: <1a8d5c2322900734c6f8ca3c6865ae81ec180e16.1372814257.git.ecashin@coraid.com>
In-Reply-To: <cover.1372814257.git.ecashin@coraid.com>
References: <cover.1372814257.git.ecashin@coraid.com>
Subject: [PATCH 3/3] aoe: update internal version number to v83
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 2 Jul 2013 21:51:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
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

