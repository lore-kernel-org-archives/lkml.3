Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaDEVge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:36:34 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34855 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaDEVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:34:09 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 04/10] driver: staging: wlan-ng: Setting character pointers as const
Date: Sat,  5 Apr 2014 23:34:01 +0200
Message-Id: <1396733641-15871-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed declaration of ctlx_str to:
static const char * const ctlx_str[]

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 01284ea..74db234 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -272,7 +272,7 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode);
 
 static inline const char *ctlxstr(CTLX_STATE s)
 {
-	static const char *ctlx_str[] = {
+	static const char * const ctlx_str[] = {
 		"Initial state",
 		"Complete",
 		"Request failed",
-- 
1.7.9.5

