Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809AbaGYQf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:35:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52297 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaGYQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:35:25 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from iwctl.h
Date: Fri, 25 Jul 2014 19:35:12 +0300
Message-Id: <1406306112-32522-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from iwctl.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/iwctl.h |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index 871bd7c..83a5a2d 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -31,14 +31,6 @@
 
 #include "device.h"
 
-/*---------------------  Export Definitions -------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev);
 
 int iwctl_siwap(struct net_device *dev,
@@ -171,7 +163,6 @@ int iwctl_siwscan(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra);
 
-//2008-0409-07, <Add> by Einsn Liu
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 int iwctl_siwauth(struct net_device *dev,
 		  struct iw_request_info *info,
@@ -207,8 +198,7 @@ int iwctl_siwmlme(struct net_device *dev,
 		  struct iw_request_info *info,
 		  struct iw_point *wrq,
 		  char *extra);
-#endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
-//End Add -- //2008-0409-07, <Add> by Einsn Liu
+#endif
 
 extern const struct iw_handler_def	iwctl_handler_def;
 extern const struct iw_priv_args	iwctl_private_args;
-- 
1.7.9.5

