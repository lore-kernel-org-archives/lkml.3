Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab3LSNNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:13:25 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54884 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab3LSNNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:13:21 -0500
From: Laszlo Papp <lpapp@kde.org>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] mfd: Fix the header file name in some copyrights section
Date: Thu, 19 Dec 2013 13:08:43 +0000
Message-Id: <1387458523-9684-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original author(s) probably only made a copy/paste from the existing public
header, and that is how this issue could sneak in. It is now more consistent
with the rest where this file name is proper in the copyrights section.
Arguably, the file name could be removed from there, but this is now just done
for catching up with the way how it is done in certain other similar headers.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 include/linux/mfd/max77686-private.h | 2 +-
 include/linux/mfd/max8997-private.h  | 2 +-
 include/linux/mfd/max8998-private.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/max77686-private.h b/include/linux/mfd/max77686-private.h
index d327d49..8c75a9c 100644
--- a/include/linux/mfd/max77686-private.h
+++ b/include/linux/mfd/max77686-private.h
@@ -1,5 +1,5 @@
 /*
- * max77686.h - Voltage regulator driver for the Maxim 77686
+ * max77686-private.h - Voltage regulator driver for the Maxim 77686
  *
  *  Copyright (C) 2012 Samsung Electrnoics
  *  Chiwoong Byun <woong.byun@samsung.com>
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index fb465df..ad1ae7f 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -1,5 +1,5 @@
 /*
- * max8997.h - Voltage regulator driver for the Maxim 8997
+ * max8997-private.h - Voltage regulator driver for the Maxim 8997
  *
  *  Copyright (C) 2010 Samsung Electrnoics
  *  MyungJoo Ham <myungjoo.ham@samsung.com>
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index 84844e0..4ecb24b 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -1,5 +1,5 @@
 /*
- * max8998.h - Voltage regulator driver for the Maxim 8998
+ * max8998-private.h - Voltage regulator driver for the Maxim 8998
  *
  *  Copyright (C) 2009-2010 Samsung Electrnoics
  *  Kyungmin Park <kyungmin.park@samsung.com>
-- 
1.8.5.1

