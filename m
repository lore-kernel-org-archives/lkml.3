Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaIILDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:03:06 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56546 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbaIILDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:03:01 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        broonie@kernel.org, linux-input@vger.kernel.org, lrg@slimlogic.co.uk,
        rdunlap@infradead.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Input:wm971x: Fix typo in module param description of wm971[23].c
Date: Tue,  9 Sep 2014 20:02:48 +0900
Message-Id: <1410260568-13955-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.60.g85f0837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo in module parameter
description of wm9712.c and wm9713.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/input/touchscreen/wm9712.c | 2 +-
 drivers/input/touchscreen/wm9713.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/wm9712.c b/drivers/input/touchscreen/wm9712.c
index 16b5211..705ffa1 100644
--- a/drivers/input/touchscreen/wm9712.c
+++ b/drivers/input/touchscreen/wm9712.c
@@ -41,7 +41,7 @@
  */
 static int rpu = 8;
 module_param(rpu, int, 0);
-MODULE_PARM_DESC(rpu, "Set internal pull up resitor for pen detect.");
+MODULE_PARM_DESC(rpu, "Set internal pull up resistor for pen detect.");
 
 /*
  * Set current used for pressure measurement.
diff --git a/drivers/input/touchscreen/wm9713.c b/drivers/input/touchscreen/wm9713.c
index 7405353..572a5a6 100644
--- a/drivers/input/touchscreen/wm9713.c
+++ b/drivers/input/touchscreen/wm9713.c
@@ -41,7 +41,7 @@
  */
 static int rpu = 8;
 module_param(rpu, int, 0);
-MODULE_PARM_DESC(rpu, "Set internal pull up resitor for pen detect.");
+MODULE_PARM_DESC(rpu, "Set internal pull up resistor for pen detect.");
 
 /*
  * Set current used for pressure measurement.
-- 
2.1.0.60.g85f0837

