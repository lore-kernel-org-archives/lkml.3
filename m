Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaLVB1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:27:31 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58786 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbaLVB10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:26 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] dgnc/dpacompat.h: checkpatch: Changend complex macros (enclosed parantheses)
Date: Mon, 22 Dec 2014 02:17:32 +0100
Message-Id: <1419211054-3052-5-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dpacompat.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgnc/dpacompat.h b/drivers/staging/dgnc/dpacompat.h
index feb4f60..8049e9d 100644
--- a/drivers/staging/dgnc/dpacompat.h
+++ b/drivers/staging/dgnc/dpacompat.h
@@ -51,7 +51,7 @@ struct ni_info {
 
 #define RW_READ		1
 #define RW_WRITE        2
-#define DIGI_KME        ('e'<<8) | 98           /* Read/Write Host */
+#define DIGI_KME        (('e'<<8) | 98)		/* Read/Write Host */
 
 #define SUBTYPE         0007
 #define T_PCXI          0000
@@ -106,12 +106,13 @@ struct ni_info {
 
 /* Ioctls needed for dpa operation */
 
-#define DIGI_GETDD      ('d'<<8) | 248          /* get driver info      */
-#define DIGI_GETBD      ('d'<<8) | 249          /* get board info       */
-#define DIGI_GET_NI_INFO ('d'<<8) | 250		/* nonintelligent state snfo */
+#define DIGI_GETDD      (('d'<<8) | 248)          /* get driver info      */
+#define DIGI_GETBD      (('d'<<8) | 249)          /* get board info       */
+#define DIGI_GET_NI_INFO	(('d'<<8) | 250)  /* nonintelligent
+						   * state snfo */
 
 /* Other special ioctls */
-#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable
+#define DIGI_TIMERIRQ (('d'<<8) | 251)		/* Enable/disable
 						 * RS_TIMER use */
-#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART
+#define DIGI_LOOPBACK (('d'<<8) | 252)		/* Enable/disable UART
 						 * internal loopback */
-- 
1.9.1

