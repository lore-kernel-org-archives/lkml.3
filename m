Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaIFIWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 04:22:38 -0400
Received: from mx02.posteo.de ([89.146.194.165]:42165 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaIFIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:22:33 -0400
Date: Sat, 6 Sep 2014 10:13:09 +0200
From: Andreas Schlick <ninox@posteo.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: rtl8821ae: Fix sparse warning by making functions
 static.
Message-ID: <20140906101309.3a7f5e7d@ninox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Schlick <ninox@posteo.net>
---
 drivers/staging/rtl8821ae/rtl8821ae/hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8821ae/rtl8821ae/hw.c b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
index 1aa1661..0539105 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/hw.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/hw.c
@@ -1067,7 +1067,7 @@ static u16 _rtl8821ae_mdio_read(struct rtl_priv *rtlpriv, u8 addr)
 	return ret;
 }
 
-void _rtl8821ae_mdio_write(struct rtl_priv *rtlpriv, u8 addr, u16 data)
+static void _rtl8821ae_mdio_write(struct rtl_priv *rtlpriv, u8 addr, u16 data)
 {
 	u8 tmp = 0, count = 0;
 
@@ -1103,7 +1103,7 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
 	return ret;
 }
 
-void _rtl8821ae_dbi_write(struct rtl_priv *rtlpriv, u16 addr, u8 data)
+static void _rtl8821ae_dbi_write(struct rtl_priv *rtlpriv, u16 addr, u8 data)
 {
 	u8 tmp = 0, count = 0;
 	u16 wrtie_addr, remainder = addr % 4;
@@ -1327,7 +1327,7 @@ void _rtl8821ae_reset_pcie_interface_dma(struct ieee80211_hw *hw,
 #define MAC_ID_STATIC_FOR_BT_CLIENT_END				3
 // -----------------------------------------------------------
 
-void rtl8821ae_macid_initialize_mediastatus(struct ieee80211_hw *hw)
+static void rtl8821ae_macid_initialize_mediastatus(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u8	media_rpt[4] = {RT_MEDIA_CONNECT, 1, \
-- 
2.1.0

