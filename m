Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbaHVQpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:45:41 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36493 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaHVQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:45:25 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: media: i2c: adv7343_regs.h: Fix typo in #ifndef
Date: Fri, 22 Aug 2014 18:45:17 +0200
Message-Id: <1408725917-2842-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test for definedness of the macro which is actually defined, and which
matches the name of the file.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/media/i2c/adv7343_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7343_regs.h b/drivers/media/i2c/adv7343_regs.h
index 4466067..2f04ce4 100644
--- a/drivers/media/i2c/adv7343_regs.h
+++ b/drivers/media/i2c/adv7343_regs.h
@@ -13,7 +13,7 @@
  * GNU General Public License for more details.
  */
 
-#ifndef ADV7343_REG_H
+#ifndef ADV7343_REGS_H
 #define ADV7343_REGS_H
 
 struct adv7343_std_info {
-- 
2.0.4

