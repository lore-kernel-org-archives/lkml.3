Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3AKFbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 00:31:13 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49232 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3AKFbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 00:31:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: ben@decadent.org.uk
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi/rtl8188ee: Add firmware for new driver
Date: Thu, 10 Jan 2013 23:30:44 -0600
Message-Id: <1357882244-8853-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 WHENCE                 |    8 ++++++++
 rtlwifi/rtl8188efw.bin |  Bin 0 -> 11216 bytes
 2 files changed, 8 insertions(+)
 create mode 100644 rtlwifi/rtl8188efw.bin

diff --git a/WHENCE b/WHENCE
index c445856..f84bec0 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1810,6 +1810,14 @@ File: rtlwifi/rtl8723fw_B.bin
 Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
 
 --------------------------------------------------------------------------
+Driver: rtl8188ee - Realtek 802.11n WLAN driver for RTL8188EE
+
+Info: Taken from Realtek version rtl_92ce_92se_92de_8723ae_88ee_linux_mac80211_0010.0109.2013
+File: rtlwifi/rtl8188efw.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
+
+--------------------------------------------------------------------------
 
 Driver: rtk_btusb - Realtek Bluetooth driver
 
diff --git a/rtlwifi/rtl8188efw.bin b/rtlwifi/rtl8188efw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..ac9a430a8350ac533153068a8c2eb24e2e76dc65
GIT binary patch
literal 11216
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

literal 0
HcmV?d00001

-- 
1.7.10.4

