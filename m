Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3LAPn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 10:43:56 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52025 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3LAPn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 10:43:26 -0500
X-Originating-IP: 109.242.63.236
From: Aldo Iljazi <mail@aldo.io>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Drivers: staging: dgap: checkpatch.pl cleanups
Date: Sun,  1 Dec 2013 17:43:09 +0200
Message-Id: <1385912589-32709-2-git-send-email-mail@aldo.io>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385912589-32709-1-git-send-email-mail@aldo.io>
References: <1385912589-32709-1-git-send-email-mail@aldo.io>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few checkpatch cleanups, particularly:

Lines 26, 60: Removed trailing whitespace.
Lines 36-38, 42-44, 47: Removed spaces at the start of the lines.

Signed-off-by: Aldo Iljazi <mail@aldo.io>
---
 drivers/staging/dgap/dgap_downld.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/dgap/dgap_downld.h b/drivers/staging/dgap/dgap_downld.h
index 271ac19..b471284 100644
--- a/drivers/staging/dgap/dgap_downld.h
+++ b/drivers/staging/dgap/dgap_downld.h
@@ -23,7 +23,7 @@
  */
 
 /*
-** downld.h 
+** downld.h
 **  - describes the interface between the user level download process
 **    and the concentrator download driver.
 */
@@ -33,18 +33,18 @@
 
 
 struct fepimg {
-    int type;				/* board type */
-    int	len;				/* length of image */
-    char fepimage[1];			/* beginning of image */
+	int type;				/* board type */
+	int	len;				/* length of image */
+	char fepimage[1];			/* beginning of image */
 };
 
 struct downldio {
-    unsigned int req_type;		/* FEP or concentrator */
-    unsigned int bdid;			/* opaque board identifier */
-    union {
-	struct downld_t dl;		/* download structure */
-	struct fepimg   fi;		/* fep/bios image structure */
-    } image;
+	unsigned int req_type;		/* FEP or concentrator */
+	unsigned int bdid;			/* opaque board identifier */
+	union {
+		struct downld_t dl;		/* download structure */
+		struct fepimg   fi;		/* fep/bios image structure */
+	} image;
 };
 
 #define DIGI_DLREQ_GET	(('d'<<8) | 220)
@@ -57,7 +57,7 @@ struct downldio {
 #define DIGI_NUKE_RESET_ALL	 (1 << 31)
 #define DIGI_NUKE_INHIBIT_POLLER (1 << 30)
 #define DIGI_NUKE_BRD_NUMB        0x0f
-	
+
 
 
 #define	DLREQ_BIOS	0
-- 
1.7.9.5

