Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaGaFbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:31:50 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64525 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaGaFbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:31:47 -0400
From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
To: <gregkh@linuxfoundation.org>
CC: <oort10@gmail.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Subject: [PATCH v2 2/3] staging:r8180: coding style: Fixed too long lines
Date: Thu, 31 Jul 2014 11:13:30 +0530
Message-ID: <1406785411-12538-3-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1406785411-12538-1-git-send-email-sanjeev_sharma@mentor.com>
References: <1406785411-12538-1-git-send-email-sanjeev_sharma@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 31 Jul 2014 05:31:45.0389 (UTC) FILETIME=[B7A551D0:01CFAC80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8180_93cx6.h file that fixes
long lines along with some additional warning.

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
Changes in v2:
  - Added signed-off field.

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

