Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaLVB11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:27:27 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58773 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545AbaLVB1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:25 -0500
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2014 20:27:25 EST
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] dgnc/dpacompat.h: checkpatch: fixed long lines bei moving comments
Date: Mon, 22 Dec 2014 02:17:31 +0100
Message-Id: <1419211054-3052-4-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dpacompat.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dpacompat.h b/drivers/staging/dgnc/dpacompat.h
index b2d2dc0..feb4f60 100644
--- a/drivers/staging/dgnc/dpacompat.h
+++ b/drivers/staging/dgnc/dpacompat.h
@@ -111,5 +111,7 @@ struct ni_info {
 #define DIGI_GET_NI_INFO ('d'<<8) | 250		/* nonintelligent state snfo */
 
 /* Other special ioctls */
-#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable RS_TIMER use */
-#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART internal loopback */
+#define DIGI_TIMERIRQ ('d'<<8) | 251		/* Enable/disable
+						 * RS_TIMER use */
+#define DIGI_LOOPBACK ('d'<<8) | 252		/* Enable/disable UART
+						 * internal loopback */
-- 
1.9.1

