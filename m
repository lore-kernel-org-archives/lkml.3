Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbaGYQbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:31:41 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42831 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaGYQbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:31:40 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from ioctl.h
Date: Fri, 25 Jul 2014 19:31:26 +0300
Message-Id: <1406305886-32351-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from ioctl.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/ioctl.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/vt6655/ioctl.h b/drivers/staging/vt6655/ioctl.h
index 2f0db92..187fc91 100644
--- a/drivers/staging/vt6655/ioctl.h
+++ b/drivers/staging/vt6655/ioctl.h
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
 int private_ioctl(PSDevice pDevice, struct ifreq *rq);
 
 #endif // __IOCTL_H__
-- 
1.7.9.5

