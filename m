Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbaGYQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:33:19 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58833 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaGYQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:33:18 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from iowpa.h
Date: Fri, 25 Jul 2014 19:33:04 +0300
Message-Id: <1406305984-32436-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from iowpa.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/iowpa.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/vt6655/iowpa.h b/drivers/staging/vt6655/iowpa.h
index b7bd190..772bc4c 100644
--- a/drivers/staging/vt6655/iowpa.h
+++ b/drivers/staging/vt6655/iowpa.h
@@ -29,8 +29,6 @@
 #ifndef __IOWPA_H__
 #define __IOWPA_H__
 
-/*---------------------  Export Definitions -------------------------*/
-
 #define WPA_IE_LEN 64
 
 //WPA related
@@ -127,14 +125,6 @@ struct viawget_scan_result {
 	int maxrate;
 };
 
-//2006-1116-01,<Add> by NomadZhao
 #pragma pack()
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
 
 #endif //__IOWPA_H__
-- 
1.7.9.5

