Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaG2JpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:45:08 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:34020 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaG2JpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:45:06 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <andrea.merello@gmail.com>, <linville@tuxdriver.com>, <anarey@gmail.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>
Subject: [PATCH] staging:r8180: coding style: Fixed too long lines
Date: Tue, 29 Jul 2014 15:27:19 +0530
Message-ID: <1406627839-20078-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 29 Jul 2014 09:45:05.0334 (UTC) FILETIME=[C6B15D60:01CFAB11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_93cx6.h file that fixes
long lines along with some additional warning.
---
 drivers/staging/rtl8192u/r8180_93cx6.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8180_93cx6.h b/drivers/staging/rtl8192u/r8180_93cx6.h
index ee55dbf..b840348 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.h
+++ b/drivers/staging/rtl8192u/r8180_93cx6.h
@@ -3,11 +3,14 @@
 	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
-	Parts of this driver are based on the GPL part of the official realtek driver
-	Parts of this driver are based on the rtl8180 driver skeleton from Patric Schenke & Andres Salomon
+	Parts of this driver are based on the GPL part of the
+	official realtek driver
+	Parts of this driver are based on the rtl8180 driver skeleton
+	from Patric Schenke & Andres Salomon
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-	We want to thank the Authors of such projects and the Ndiswrapper project Authors.
+	We want to thank the Authors of such projects and the Ndiswrapper
+	project Authors.
 */
 
 /*This files contains card eeprom (93c46 or 93c56) programming routines*/
@@ -37,4 +40,4 @@
 #define EPROM_TXPW1 0x3d
 
 
-u32 eprom_read(struct net_device *dev,u32 addr); //reads a 16 bits word
+u32 eprom_read(struct net_device *dev, u32 addr); /* reads a 16 bits word */
-- 
1.7.11.7

