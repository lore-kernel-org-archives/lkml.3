Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaG3Npb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:45:31 -0400
Received: from smtp105.ord1c.emailsrvr.com ([108.166.43.105]:50105 "EHLO
	smtp105.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937AbaG3Np2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:45:28 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/2] Input: jornada720_ts: Get rid of space indentation and use tab
Date: Wed, 30 Jul 2014 19:18:27 +0530
Message-Id: <1406728107-26969-2-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406728107-26969-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1406728107-26969-1-git-send-email-pramod.gurav@smartplayin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/touchscreen/jornada720_ts.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 7422480..5d34e3d 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -36,22 +36,21 @@ struct jornada_ts {
 
 static void jornada720_ts_collect_data(struct jornada_ts *jornada_ts)
 {
+	/* 3 low word X samples */
+	jornada_ts->x_data[0] = jornada_ssp_byte(TXDUMMY);
+	jornada_ts->x_data[1] = jornada_ssp_byte(TXDUMMY);
+	jornada_ts->x_data[2] = jornada_ssp_byte(TXDUMMY);
 
-    /* 3 low word X samples */
-    jornada_ts->x_data[0] = jornada_ssp_byte(TXDUMMY);
-    jornada_ts->x_data[1] = jornada_ssp_byte(TXDUMMY);
-    jornada_ts->x_data[2] = jornada_ssp_byte(TXDUMMY);
+	/* 3 low word Y samples */
+	jornada_ts->y_data[0] = jornada_ssp_byte(TXDUMMY);
+	jornada_ts->y_data[1] = jornada_ssp_byte(TXDUMMY);
+	jornada_ts->y_data[2] = jornada_ssp_byte(TXDUMMY);
 
-    /* 3 low word Y samples */
-    jornada_ts->y_data[0] = jornada_ssp_byte(TXDUMMY);
-    jornada_ts->y_data[1] = jornada_ssp_byte(TXDUMMY);
-    jornada_ts->y_data[2] = jornada_ssp_byte(TXDUMMY);
+	/* combined x samples bits */
+	jornada_ts->x_data[3] = jornada_ssp_byte(TXDUMMY);
 
-    /* combined x samples bits */
-    jornada_ts->x_data[3] = jornada_ssp_byte(TXDUMMY);
-
-    /* combined y samples bits */
-    jornada_ts->y_data[3] = jornada_ssp_byte(TXDUMMY);
+	/* combined y samples bits */
+	jornada_ts->y_data[3] = jornada_ssp_byte(TXDUMMY);
 }
 
 static int jornada720_ts_average(int coords[4])
-- 
1.7.9.5

