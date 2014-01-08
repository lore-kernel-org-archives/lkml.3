Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbaAHR1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:27:24 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41549 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbaAHR1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:27:23 -0500
From: Laszlo Papp <lpapp@kde.org>
To: broonie@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] include/linux/regmap.h: fix a couple of typos
Date: Wed,  8 Jan 2014 17:22:18 +0000
Message-Id: <1389201738-31406-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These sentences are not proper English due to the typos. I had initially caught
one of them while trying to understand the regmap feature, and then I just ran
the vim spell checker, and went through all the items that would need to be
fixed for this header file.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 include/linux/regmap.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e559078..6305657 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -122,9 +122,9 @@ typedef void (*regmap_unlock)(void *);
  *		  volatile_table (see below) is not, the check is performed on
  *                such table (a register is volatile if it belongs to one of
  *                the ranges specified by volatile_table).
- * @precious_reg: Optional callback returning true if the rgister
+ * @precious_reg: Optional callback returning true if the register
  *		  should not be read outside of a call from the driver
- *		  (eg, a clear on read interrupt status register). If this
+ *		  (e.g. a clear on read interrupt status register). If this
  *                field is NULL but precious_table (see below) is not, the
  *                check is performed on such table (a register is precious if
  *                it belongs to one of the ranges specified by precious_table).
@@ -136,9 +136,9 @@ typedef void (*regmap_unlock)(void *);
  *		  are not overridden).
  * @reg_read:	  Optional callback that if filled will be used to perform
  *           	  all the reads from the registers. Should only be provided for
- *		  devices whos read operation cannot be represented as a simple read
- *		  operation on a bus such as SPI, I2C, etc. Most of the devices do
- * 		  not need this.
+ *		  devices whose read operation cannot be represented as a simple
+ *		  read operation on a bus such as SPI, I2C, etc. Most of the
+ *		  devices do not need this.
  * @reg_write:	  Same as above for writing.
  * @fast_io:	  Register IO is fast. Use a spinlock instead of a mutex
  *	     	  to perform locking. This field is ignored if custom lock/unlock
-- 
1.8.5.1

