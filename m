Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab3CUUVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:21:15 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:53973 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967Ab3CUUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:21:13 -0400
Message-ID: <1363897258.1390.153.camel@x61.thuisdomein>
Subject: [PATCH] video: nuc900fb: remove "config FB_NUC900_DEBUG"
From: Paul Bolle <pebolle@tiscali.nl>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 21:20:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 20:21:07.0762 (UTC) FILETIME=[9ECB8120:01CE2671]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the NUC900 LCD Controller Driver got added (in v3.4) a Kconfig
entry for FB_NUC900_DEBUG got added too. It has never been used. It
appears that its users were dropped during review. Anyhow, this entry
can be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/video/Kconfig | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 4c1546f..fba178b 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2107,13 +2107,6 @@ config GPM1040A0_320X240
         bool "Giantplus Technology GPM1040A0 320x240 Color TFT LCD"
         depends on FB_NUC900
 
-config FB_NUC900_DEBUG
-        bool "NUC900 lcd debug messages"
-        depends on FB_NUC900
-        help
-          Turn on debugging messages. Note that you can set/unset at run time
-          through sysfs
-
 config FB_SM501
 	tristate "Silicon Motion SM501 framebuffer support"
 	depends on FB && MFD_SM501
-- 
1.7.11.7

