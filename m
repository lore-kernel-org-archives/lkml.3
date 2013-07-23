Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3GWVUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:20:05 -0400
Received: from dupo.coraid.com ([208.71.232.133]:47769 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758129Ab3GWVUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:20:03 -0400
Message-Id: <75ef8d8b4d62d4828f257e0205538f2c7022af9e.1374610591.git.ecashin@coraid.com>
In-Reply-To: <cover.1374610591.git.ecashin@coraid.com>
References: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 6/6] aoe: update internal version number to 85
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:19:56 -0400
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
index b1f24c5..14a9d19 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "83"
+#define VERSION "85"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.7.1

