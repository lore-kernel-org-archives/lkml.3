Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3GCCGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:06:04 -0400
Received: from dupo.coraid.com ([208.71.232.133]:34204 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753143Ab3GCCGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:06:03 -0400
Message-Id: <e3cf127b854a624c06dbdd3879efb037ff30753a.1372814257.git.ecashin@coraid.com>
In-Reply-To: <cover.1372814257.git.ecashin@coraid.com>
References: <cover.1372814257.git.ecashin@coraid.com>
Subject: [PATCH 2/3] aoe: update copyright date
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 2 Jul 2013 21:49:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoecmd.c |    2 +-
 drivers/block/aoe/aoedev.c |    2 +-
 drivers/block/aoe/aoenet.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index c969852..2284f89 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "81"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 19955dd..99cb944 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 92201b6..784c92e 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 4af5f06..63773a9 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
-- 
1.7.1

