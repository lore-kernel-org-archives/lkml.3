Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3CEItF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:49:05 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51277 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754827Ab3CEItD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:49:03 -0500
Message-ID: <1362473341.16460.57.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] Fix typo "-- help---"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 09:49:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 08:49:01.0738 (UTC) FILETIME=[48BF18A0:01CE197E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
The kconfig parsing code doesn't care about this typo, but it's a typo
nevertheless.

 drivers/hid/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 5f07d85..49e2939 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -738,7 +738,7 @@ config HID_SENSOR_HUB
 	depends on USB_HID && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
-	-- help---
+	---help---
 	  Support for HID Sensor framework. This creates a MFD instance
 	  for a sensor hub and identifies all the sensors connected to it.
 	  Each sensor is registered as a MFD cell, so that sensor specific
-- 
1.7.11.7



