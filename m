Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540Ab3GSFZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:25:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965439Ab3GSFW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Axel=20K=C3=B6llhofer?= <AxelKoellhofer@web.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 03/38] rtlwifi: rtl8723ae: Fix typo in firmware names
Date: Thu, 18 Jul 2013 22:21:19 -0700
Message-Id: <20130719052048.107918798@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 73e088ed17c2880a963cc760a78af8a06d4a4d9d upstream.

The driver loads its firmware from files rtlwifi/rtl8723fw*.bin, but the
MODULE_FIRMWARE macros refer to rtlwifi/RTL8723aefw*.bin.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Axel Köllhofer <AxelKoellhofer@web.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
@@ -251,7 +251,7 @@ static struct rtl_hal_cfg rtl8723ae_hal_
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723ae_pci",
-	.fw_name = "rtlwifi/rtl8723aefw.bin",
+	.fw_name = "rtlwifi/rtl8723fw.bin",
 	.ops = &rtl8723ae_hal_ops,
 	.mod_params = &rtl8723ae_mod_params,
 	.maps[SYS_ISO_CTRL] = REG_SYS_ISO_CTRL,
@@ -353,8 +353,8 @@ MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@
 MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 8723E 802.11n PCI wireless");
-MODULE_FIRMWARE("rtlwifi/rtl8723aefw.bin");
-MODULE_FIRMWARE("rtlwifi/rtl8723aefw_B.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723fw.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8723fw_B.bin");
 
 module_param_named(swenc, rtl8723ae_mod_params.sw_crypto, bool, 0444);
 module_param_named(debug, rtl8723ae_mod_params.debug, int, 0444);


