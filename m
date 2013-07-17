Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab3GQWxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:53:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3GQWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 105/145] rtlwifi: rtl8723ae: Fix typo in firmware names
Date: Wed, 17 Jul 2013 15:47:17 -0700
Message-Id: <1374101277-7915-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 73e088ed17c2880a963cc760a78af8a06d4a4d9d upstream.

The driver loads its firmware from files rtlwifi/rtl8723fw*.bin, but the
MODULE_FIRMWARE macros refer to rtlwifi/RTL8723aefw*.bin.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Axel Köllhofer <AxelKoellhofer@web.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
index bb7cc90..2b2a522 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -251,7 +251,7 @@ static struct rtl_hal_cfg rtl8723ae_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723ae_pci",
-	.fw_name = "rtlwifi/rtl8723aefw.bin",
+	.fw_name = "rtlwifi/rtl8723fw.bin",
 	.ops = &rtl8723ae_hal_ops,
 	.mod_params = &rtl8723ae_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
@@ -353,8 +353,8 @@ MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8723E 802.11n PCI wireless");
-MODULE_FIRMWARE("rtlwifi/rtl8723aefw.bin");
-MODULE_FIRMWARE("rtlwifi/rtl8723aefw_B.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723fw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723fw_B.bin");
 
 module_param_named(swenc, rtl8723ae_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl8723ae_mod_params.debug, int, 0444);
-- 
1.8.1.2

