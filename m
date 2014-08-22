Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbaHVQ7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:59:05 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:64285 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409AbaHVQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:59:03 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: memstick: host: r592.h: Add missing #define
Date: Fri, 22 Aug 2014 18:58:55 +0200
Message-Id: <1408726735-3283-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly this was meant to be an include guard, but the
#define was missing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/memstick/host/r592.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/memstick/host/r592.h b/drivers/memstick/host/r592.h
index c5726c1..3d80c21 100644
--- a/drivers/memstick/host/r592.h
+++ b/drivers/memstick/host/r592.h
@@ -8,6 +8,7 @@
  */
 
 #ifndef R592_H
+#define R592_H
 
 #include <linux/memstick.h>
 #include <linux/spinlock.h>
-- 
2.0.4

