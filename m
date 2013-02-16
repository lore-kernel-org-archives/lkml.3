Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3BPNBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 08:01:39 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:59902 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3BPNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 08:01:38 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: garrickhe@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: hfa384x.h: fix for error reported by smatch
Date: Sat, 16 Feb 2013 05:01:22 -0800
Message-Id: <1361019682-15655-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the missing header include for 'struct urb' datatypes to avoid
potential build issues. Found using smatch.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 04c0433..3dfa85c 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -59,6 +59,7 @@
 #define HFA384x_FIRMWARE_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
 
 #include <linux/if_ether.h>
+#include <linux/usb.h>
 
 /*--- Mins & Maxs -----------------------------------*/
 #define	HFA384x_PORTID_MAX		((u16)7)
-- 
1.7.9.5

