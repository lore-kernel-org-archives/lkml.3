Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaHHX1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:27:08 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:49176 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaHHX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:27:03 -0400
Date: Sat, 9 Aug 2014 01:26:45 +0200
From: Martin Berglund <martin@rogsta.net>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: iowpa.h: Fix sparse warnings
Message-ID: <20140808232645.GA22132@licorice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resolves a sparse address space warning in wpactl.c

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
 drivers/staging/vt6655/iowpa.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/iowpa.h b/drivers/staging/vt6655/iowpa.h
index 772bc4c..fe4b22e 100644
--- a/drivers/staging/vt6655/iowpa.h
+++ b/drivers/staging/vt6655/iowpa.h
@@ -75,7 +75,7 @@ struct viawget_wpa_param {
 			u8 bssid[6];
 			u8 ssid[32];
 			u8 ssid_len;
-			u8 *wpa_ie;
+			u8 __user *wpa_ie;
 			u16 wpa_ie_len;
 			int pairwise_suite;
 			int group_suite;
@@ -102,7 +102,7 @@ struct viawget_wpa_param {
 
 		struct {
 			u16 scan_count;
-			u8 *buf;
+			u8 __user *buf;
 		} scan_results;
 
 	} u;
-- 
1.7.10.4

