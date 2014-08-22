Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbaHVNJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:09:47 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61862 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbaHVNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:09:45 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] dt-bindings/mfs/palmas.h: Fix typo in include guard
Date: Fri, 22 Aug 2014 15:09:24 +0200
Message-Id: <1408712964-14930-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/dt-bindings/mfd/palmas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/dt-bindings/mfd/palmas.h b/include/dt-bindings/mfd/palmas.h
index 2c8ac48..f4db7df 100644
--- a/include/dt-bindings/mfd/palmas.h
+++ b/include/dt-bindings/mfd/palmas.h
@@ -8,11 +8,11 @@
  */
 
 #ifndef __DT_BINDINGS_PALMAS_H__
-#define __DT_BINDINGS_PALMAS_H
+#define __DT_BINDINGS_PALMAS_H__
 
 /* External control pins */
 #define PALMAS_EXT_CONTROL_PIN_ENABLE1	1
 #define PALMAS_EXT_CONTROL_PIN_ENABLE2	2
 #define PALMAS_EXT_CONTROL_PIN_NSLEEP	3
 
-#endif /* __DT_BINDINGS_PALMAS_H */
+#endif /* __DT_BINDINGS_PALMAS_H__ */
-- 
1.9.2

