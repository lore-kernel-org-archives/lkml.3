Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaLUCyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 21:54:40 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46964 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaLUCyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 21:54:39 -0500
From: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org,
        Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Subject: [PATCH] staging: rtl8192e: fixed a space coding style issue
Date: Sun, 21 Dec 2014 08:23:59 +0530
Message-Id: <1419130439-4248-1-git-send-email-gangs.freelancer@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a space coding style issue in 3-dimensional array initialization
which was found when running checkpatch.pl script on rtl819x_HTProc.c.

Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
---
 drivers/staging/rtl8192e/rtl819x_HTProc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl819x_HTProc.c b/drivers/staging/rtl8192e/rtl819x_HTProc.c
index c7f4508..1ea426b 100644
--- a/drivers/staging/rtl8192e/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_HTProc.c
@@ -34,13 +34,13 @@ u16 MCS_DATA_RATE[2][2][77] = {
 	 468, 520, 0, 78, 104, 130, 117, 156, 195, 104, 130, 130, 156, 182,
 	 182, 208, 156, 195, 195, 234, 273, 273, 312, 130, 156, 181, 156,
 	 181, 208, 234, 208, 234, 260, 260, 286, 195, 234, 273, 234, 273,
-	 312, 351, 312, 351, 390, 390, 429} ,
+	 312, 351, 312, 351, 390, 390, 429},
 	{14, 29, 43, 58, 87, 116, 130, 144, 29, 58, 87, 116, 173, 231, 260, 289,
 	 43, 87, 130, 173, 260, 347, 390, 433, 58, 116, 173, 231, 347, 462, 520,
 	 578, 0, 87, 116, 144, 130, 173, 217, 116, 144, 144, 173, 202, 202, 231,
 	 173, 217, 217, 260, 303, 303, 347, 144, 173, 202, 173, 202, 231, 260,
 	 231, 260, 289, 289, 318, 217, 260, 303, 260, 303, 347, 390, 347, 390,
-	 433, 433, 477} } ,
+	 433, 433, 477} },
 	{{27, 54, 81, 108, 162, 216, 243, 270, 54, 108, 162, 216, 324, 432, 486,
 	 540, 81, 162, 243, 324, 486, 648, 729, 810, 108, 216, 324, 432, 648,
 	 864, 972, 1080, 12, 162, 216, 270, 243, 324, 405, 216, 270, 270, 324,
-- 
Gangadhar Vukkesala

