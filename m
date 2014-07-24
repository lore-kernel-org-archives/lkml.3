Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaGXXJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:09:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44091 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915AbaGXXHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:09 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 10/14] staging: vt6655: add missing whitespace
Date: Fri, 25 Jul 2014 01:06:24 +0200
Message-Id: <1406243188-13413-11-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some whitespace were missing, causing checkpatch warnings and altering
readability.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/device_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 7bd728c..33a25bc 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -2619,12 +2619,12 @@ static int Config_FileGetParameter(unsigned char *string,
 	return true;
 }
 
-int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Parameter)
+int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Parameter)
 {
 	unsigned char *buffer = kmalloc(1024, GFP_KERNEL);
 	unsigned char tmpbuffer[20];
 	struct file *file;
-	int result=0;
+	int result = 0;
 
 	if (!buffer) {
 		pr_err("allocate mem for file fail?\n");
@@ -2649,11 +2649,11 @@ int Config_FileOperation(PSDevice pDevice,bool fwrite,unsigned char *Parameter)
 		goto error1;
 	}
 
-	if (memcmp(tmpbuffer,"USA",3)==0) {
+	if (memcmp(tmpbuffer, "USA", 3) == 0) {
 		result = ZoneType_USA;
-	} else if(memcmp(tmpbuffer,"JAPAN",5)==0) {
+	} else if(memcmp(tmpbuffer, "JAPAN", 5) == 0) {
 		result = ZoneType_Japan;
-	} else if(memcmp(tmpbuffer,"EUROPE",5)==0) {
+	} else if(memcmp(tmpbuffer, "EUROPE", 5) == 0) {
 		result = ZoneType_Europe;
 	} else {
 		result = -1;
-- 
1.8.5.5

