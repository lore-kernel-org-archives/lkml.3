Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3HZMC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:02:56 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50385 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3HZMCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:02:54 -0400
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        andrea.merello@gmail.com
Subject: [PATCH 1/1] Update e-mail address for Andrea Merello (resubmit)
Date: Mon, 26 Aug 2013 13:53:30 +0200
Message-Id: <1377518010-14767-1-git-send-email-andrea.merello@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot of files contain reference to my old e-mail address.
Now I'm going not to read mail from it anymore, so update it
with my current address everywhere.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c                 | 6 +++---
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c             | 2 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.h             | 2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c             | 2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.h             | 2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c             | 4 ++--
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c              | 2 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.h              | 2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                 | 6 +++---
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h             | 4 ++--
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c             | 4 ++--
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.h             | 4 ++--
 drivers/net/wireless/rtl818x/rtl818x.h                     | 4 ++--
 drivers/staging/rtl8187se/ieee80211/ieee80211.h            | 2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c         | 2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c    | 2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c | 2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c         | 2 +-
 drivers/staging/rtl8187se/r8180.h                          | 2 +-
 drivers/staging/rtl8187se/r8180_93cx6.h                    | 2 +-
 drivers/staging/rtl8187se/r8180_core.c                     | 4 ++--
 drivers/staging/rtl8187se/r8180_hw.h                       | 2 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h                  | 2 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c                | 2 +-
 drivers/staging/rtl8187se/r8180_wx.c                       | 2 +-
 drivers/staging/rtl8187se/r8180_wx.h                       | 2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c             | 2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h             | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c                | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.h                | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c               | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h               | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c             | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h             | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c            | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c                | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.h                | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.c                 | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.h                 | 2 +-
 drivers/staging/rtl8192e/rtllib.h                          | 2 +-
 drivers/staging/rtl8192e/rtllib_debug.h                    | 2 +-
 drivers/staging/rtl8192e/rtllib_rx.c                       | 2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c                  | 2 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c               | 2 +-
 drivers/staging/rtl8192e/rtllib_tx.c                       | 2 +-
 drivers/staging/rtl8192u/authors                           | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h             | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c          | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c     | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c  | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c          | 2 +-
 drivers/staging/rtl8192u/r8180_93cx6.c                     | 2 +-
 drivers/staging/rtl8192u/r8180_93cx6.h                     | 2 +-
 drivers/staging/rtl8192u/r8180_pm.c                        | 2 +-
 drivers/staging/rtl8192u/r8180_pm.h                        | 2 +-
 drivers/staging/rtl8192u/r8190_rtl8256.h                   | 2 +-
 drivers/staging/rtl8192u/r8192U.h                          | 2 +-
 drivers/staging/rtl8192u/r8192U_core.c                     | 2 +-
 drivers/staging/rtl8192u/r8192U_hw.h                       | 2 +-
 drivers/staging/rtl8192u/r8192U_wx.c                       | 2 +-
 drivers/staging/rtl8192u/r8192U_wx.h                       | 2 +-
 61 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 91a04e2..fc207b2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -3,10 +3,10 @@
  * Linux device driver for RTL8180 / RTL8185
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * Thanks to Realtek for their support!
  *
@@ -32,7 +32,7 @@
 #include "grf5101.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
-MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
+MODULE_AUTHOR("Andrea Merello <andrea.merello@gmail.com>");
 MODULE_DESCRIPTION("RTL8180 / RTL8185 PCI wireless driver");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
index 077ff92..dc845693 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
@@ -2,7 +2,7 @@
 /*
  * Radio tuning for GCT GRF5101 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.h b/drivers/net/wireless/rtl818x/rtl8180/grf5101.h
index 7664711..4d80a27 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/grf5101.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/grf5101.h
@@ -4,7 +4,7 @@
 /*
  * Radio tuning for GCT GRF5101 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.c b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
index 4715000..a63c443 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/max2820.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
@@ -1,7 +1,7 @@
 /*
  * Radio tuning for Maxim max2820 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.h b/drivers/net/wireless/rtl818x/rtl8180/max2820.h
index 61cf6d1..8e982b7 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/max2820.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/max2820.h
@@ -4,7 +4,7 @@
 /*
  * Radio tuning for Maxim max2820 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
index cc2a541..ee638d0 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
@@ -3,10 +3,10 @@
  * Radio tuning for RTL8225 on RTL8180
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8180 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * Thanks to Realtek for their support!
  *
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
index b3ec40f..7614d9c 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
@@ -2,7 +2,7 @@
 /*
  * Radio tuning for Philips SA2400 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.h b/drivers/net/wireless/rtl818x/rtl8180/sa2400.h
index a4aaa0d..fb0093f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/sa2400.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/sa2400.h
@@ -4,7 +4,7 @@
 /*
  * Radio tuning for Philips SA2400 on RTL8180
  *
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Code from the BSD driver and the rtl8181 project have been
  * very useful to understand certain things
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index f49220e..841fb9d 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -2,10 +2,10 @@
  * Linux device driver for RTL8187
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8187 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * The driver was extended to the RTL8187B in 2008 by:
  *	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
@@ -37,7 +37,7 @@
 #include "rfkill.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
-MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
+MODULE_AUTHOR("Andrea Merello <andrea.merello@gmail.com>");
 MODULE_AUTHOR("Herton Ronaldo Krzesinski <herton@mandriva.com.br>");
 MODULE_AUTHOR("Hin-Tak Leung <htl10@users.sourceforge.net>");
 MODULE_AUTHOR("Larry Finger <Larry.Finger@lwfinger.net>");
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
index e19a20a..56aee06 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
@@ -2,10 +2,10 @@
  * Definitions for RTL8187 hardware
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8187 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
index f0bf35f..a26193a 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
@@ -2,10 +2,10 @@
  * Radio tuning for RTL8225 on RTL8187
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8187 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * Magic delays, register offsets, and phy value tables below are
  * taken from the original r8187 driver sources.  Thanks to Realtek
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
index 20c5b6e..141afb0 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
@@ -2,10 +2,10 @@
  * Radio tuning definitions for RTL8225 on RTL8187
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8187 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index 1615f63..ce23dfd 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -2,10 +2,10 @@
  * Definitions for RTL818x hardware
  *
  * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
- * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright 2007 Andrea Merello <andrea.merello@gmail.com>
  *
  * Based on the r8187 driver, which is:
- * Copyright 2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211.h b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
index 8fc9f58..7f01549 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -14,7 +14,7 @@
  * Copyright (c) 2004, Intel Corporation
  *
  * Modified for Realtek's wi-fi cards by Andrea Merello
- * <andreamrl@tiscali.it>
+ * <andrea.merello@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index d5df0d6..10b2210 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -14,7 +14,7 @@
  ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 00f9af0..b65db54 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
index d9add53..e528206 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac_wx.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
index 89ed86e..b346653 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
@@ -25,7 +25,7 @@
 ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index edacc80..d052f4a 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -1,6 +1,6 @@
 /*
    This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+   Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
    Released under the terms of GPL (General Public Licence)
 
    Parts of this driver are based on the GPL part of the
diff --git a/drivers/staging/rtl8187se/r8180_93cx6.h b/drivers/staging/rtl8187se/r8180_93cx6.h
index 79e7391..b52b5b0 100644
--- a/drivers/staging/rtl8187se/r8180_93cx6.h
+++ b/drivers/staging/rtl8187se/r8180_93cx6.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8180 OpenSource driver
-	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the official realtek driver
diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index ca69155..fd2bfead 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1,6 +1,6 @@
 /*
    This is part of rtl818x pci OpenSource driver - v 0.1
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+   Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
    Released under the terms of GPL (General Public License)
 
    Parts of this driver are based on the GPL part of the official
@@ -70,7 +70,7 @@ static int hwwep;
 
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, rtl8180_pci_id_tbl);
-MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
+MODULE_AUTHOR("Andrea Merello <andrea.merello@gmail.com>");
 MODULE_DESCRIPTION("Linux driver for Realtek RTL8187SE WiFi cards");
 
 module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
diff --git a/drivers/staging/rtl8187se/r8180_hw.h b/drivers/staging/rtl8187se/r8180_hw.h
index 5339381..92c05af 100644
--- a/drivers/staging/rtl8187se/r8180_hw.h
+++ b/drivers/staging/rtl8187se/r8180_hw.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8180 OpenSource driver.
-	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225.h b/drivers/staging/rtl8187se/r8180_rtl8225.h
index c6f2128..c94ca07 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225.h
+++ b/drivers/staging/rtl8187se/r8180_rtl8225.h
@@ -1,7 +1,7 @@
 /*
 	This is part of the rtl8180-sa2400 driver
 	released under the GPL (See file COPYING for details).
-	Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+	Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
 
 	This files contains programming code for the rtl8225
 	radio frontend.
diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index c592f79..9ae96b7 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -1,7 +1,7 @@
 /*
  * This is part of the rtl8180-sa2400 driver
  * released under the GPL (See file COPYING for details).
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * This files contains programming code for the rtl8225
  * radio frontend.
diff --git a/drivers/staging/rtl8187se/r8180_wx.c b/drivers/staging/rtl8187se/r8180_wx.c
index 156b758..dab7875 100644
--- a/drivers/staging/rtl8187se/r8180_wx.c
+++ b/drivers/staging/rtl8187se/r8180_wx.c
@@ -2,7 +2,7 @@
 	This file contains wireless extension handlers.
 
 	This is part of rtl8180 OpenSource driver.
-	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part
diff --git a/drivers/staging/rtl8187se/r8180_wx.h b/drivers/staging/rtl8187se/r8180_wx.h
index 4081914..d471520 100644
--- a/drivers/staging/rtl8187se/r8180_wx.h
+++ b/drivers/staging/rtl8187se/r8180_wx.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8180 OpenSource driver - v 0.3
-	Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the official realtek driver
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 50c7bb7..74fbd70 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h
index b9b3b52..dbe0e1c 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
index baf3b63..fa5603a 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
index fa607f9..7d075d3 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 2b6c61c..8d45c8d 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index 87d4d34..9de1dc3 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c b/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c
index c1ccff4..a6778e0 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h b/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h
index 9452e16..adea2b4 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c b/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
index 0cfb3ec..529ea54 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
index 5abbee3..2ad92ee 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
index 28c7da6..356aec4 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_pci.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
index c9a7c56..a8c2ade 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.h b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.h
index df79d6c..962f2e5 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 3485ef1..05ef49f 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -14,7 +14,7 @@
  * Copyright (c) 2004, Intel Corporation
  *
  * Modified for Realtek's wi-fi cards by Andrea Merello
- * <andreamrl@tiscali.it>
+ * <andrea.merello@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/staging/rtl8192e/rtllib_debug.h b/drivers/staging/rtl8192e/rtllib_debug.h
index 2bfc115..c59f67b 100644
--- a/drivers/staging/rtl8192e/rtllib_debug.h
+++ b/drivers/staging/rtl8192e/rtllib_debug.h
@@ -2,7 +2,7 @@
  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
  *
  * Based on the r8180 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 6a51f29..8aeaed5 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -14,7 +14,7 @@
  ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index aefffac..0cbf6f5 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index 740cf85..e6af8cf 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index 759d7c7..1cc6a9d 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -25,7 +25,7 @@
 ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8192u/authors b/drivers/staging/rtl8192u/authors
index b08bbae..0fab112 100644
--- a/drivers/staging/rtl8192u/authors
+++ b/drivers/staging/rtl8192u/authors
@@ -1 +1 @@
-Andrea Merello <andreamrl@tiscali.it>
+Andrea Merello <andrea.merello@gmail.com>
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index c9f3bb3..bc64f05 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -14,7 +14,7 @@
  * Copyright (c) 2004, Intel Corporation
  *
  * Modified for Realtek's wi-fi cards by Andrea Merello
- * <andreamrl@tiscali.it>
+ * <andrea.merello@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index a6b1840..59900bf 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -14,7 +14,7 @@
  ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 8a0075d..5fd6969 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
index 60746b8..7b7d929 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac_wx.c
@@ -1,5 +1,5 @@
 /* IEEE 802.11 SoftMAC layer
- * Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+ * Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
  *
  * Mostly extracted from the rtl8180-sa2400 driver for the
  * in-kernel generic ieee802.11 stack.
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 9955042..a7bcc64f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -25,7 +25,7 @@
 ******************************************************************************
 
   Few modifications for Realtek's Wi-Fi drivers by
-  Andrea Merello <andreamrl@tiscali.it>
+  Andrea Merello <andrea.merello@gmail.com>
 
   A special thanks goes to Realtek for their support !
 
diff --git a/drivers/staging/rtl8192u/r8180_93cx6.c b/drivers/staging/rtl8192u/r8180_93cx6.c
index d219998..c61729b 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.c
+++ b/drivers/staging/rtl8192u/r8180_93cx6.c
@@ -3,7 +3,7 @@
    memory is addressed by 16 bits words.
 
    This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+   Copyright (C) Andrea Merello 2004  <andrea.merello@gmail.com>
    Released under the terms of GPL (General Public Licence)
 
    Parts of this driver are based on the GPL part of the
diff --git a/drivers/staging/rtl8192u/r8180_93cx6.h b/drivers/staging/rtl8192u/r8180_93cx6.h
index 5cea51e..ee55dbf 100644
--- a/drivers/staging/rtl8192u/r8180_93cx6.h
+++ b/drivers/staging/rtl8192u/r8180_93cx6.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8187 OpenSource driver
-	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the official realtek driver
diff --git a/drivers/staging/rtl8192u/r8180_pm.c b/drivers/staging/rtl8192u/r8180_pm.c
index 0c58d0e..999968d 100644
--- a/drivers/staging/rtl8192u/r8180_pm.c
+++ b/drivers/staging/rtl8192u/r8180_pm.c
@@ -5,7 +5,7 @@
    does not do anything useful.
 
    This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+   Copyright (C) Andrea Merello 2004  <andrea.merello@gmail.com>
    Released under the terms of GPL (General Public Licence)
 */
 
diff --git a/drivers/staging/rtl8192u/r8180_pm.h b/drivers/staging/rtl8192u/r8180_pm.h
index 52d6fba..4be63da 100644
--- a/drivers/staging/rtl8192u/r8180_pm.h
+++ b/drivers/staging/rtl8192u/r8180_pm.h
@@ -5,7 +5,7 @@
 	does not do anything useful.
 
 	This is part of rtl8180 OpenSource driver.
-	Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 */
diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.h b/drivers/staging/rtl8192u/r8190_rtl8256.h
index b64dd66..592e780 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.h
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.h
@@ -1,7 +1,7 @@
 /*
   This is part of the rtl8180-sa2400 driver
   released under the GPL (See file COPYING for details).
-  Copyright (c) 2005 Andrea Merello <andreamrl@tiscali.it>
+  Copyright (c) 2005 Andrea Merello <andrea.merello@gmail.com>
 
   This files contains programming code for the rtl8256
   radio frontend.
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 338e7bc..b484ee1 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -1,6 +1,6 @@
 /*
  * This is part of rtl8187 OpenSource driver.
- * Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+ * Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
  * Released under the terms of GPL (General Public Licence)
  *
  * Parts of this driver are based on the GPL part of the
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 14c14c2..cd0946d 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3,7 +3,7 @@
  * Linux device driver for RTL8192U
  *
  * Based on the r8187 driver, which is:
- * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
+ * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
diff --git a/drivers/staging/rtl8192u/r8192U_hw.h b/drivers/staging/rtl8192u/r8192U_hw.h
index 7e612aa..dd07a73 100644
--- a/drivers/staging/rtl8192u/r8192U_hw.h
+++ b/drivers/staging/rtl8192u/r8192U_hw.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8187 OpenSource driver.
-	Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 3e25763..61f6620 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -2,7 +2,7 @@
    This file contains wireless extension handlers.
 
    This is part of rtl8180 OpenSource driver.
-   Copyright (C) Andrea Merello 2004-2005  <andreamrl@tiscali.it>
+   Copyright (C) Andrea Merello 2004-2005  <andrea.merello@gmail.com>
    Released under the terms of GPL (General Public Licence)
 
    Parts of this driver are based on the GPL part
diff --git a/drivers/staging/rtl8192u/r8192U_wx.h b/drivers/staging/rtl8192u/r8192U_wx.h
index 9f6b105..ae7a617 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.h
+++ b/drivers/staging/rtl8192u/r8192U_wx.h
@@ -1,6 +1,6 @@
 /*
 	This is part of rtl8180 OpenSource driver - v 0.3
-	Copyright (C) Andrea Merello 2004  <andreamrl@tiscali.it>
+	Copyright (C) Andrea Merello 2004  <andrea.merello@gmail.com>
 	Released under the terms of GPL (General Public Licence)
 
 	Parts of this driver are based on the GPL part of the official realtek driver
-- 
1.8.1.2

