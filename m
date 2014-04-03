Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162511AbaDCHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:13:10 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36393 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162367AbaDCHNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:13:06 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 4/9] driver: staging: wlan-ng: Setting character pointers as const
Date: Thu,  3 Apr 2014 09:13:01 +0200
Message-Id: <1396509181-2967-1-git-send-email-shehabaldin.sherif@gmail.com>
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
index a389cef..65e59a3 100644
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

