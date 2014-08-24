Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHXXhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 19:37:18 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:39282 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaHXXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 19:37:16 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: rtl8821ae: Fix spaces required around that '<' errors
Date: Sun, 24 Aug 2014 18:34:43 -0500
Message-Id: <1408923283-3572-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl spaces required around that '<' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c |  2 +-
 drivers/staging/rtl8821ae/rtl8821ae/phy.c             | 18 +++++++++---------
 drivers/staging/rtl8821ae/rtl8821ae/rf.c              |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
index da3f62d..edcf8dd 100644
--- a/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
+++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8723b2ant.c
@@ -1323,7 +1323,7 @@ static void halbtc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_EXT_SWITCH, &pg_ext_switch);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
 
-	if ((fw_ver<0xc0000) || pg_ext_switch)
+	if ((fw_ver < 0xc0000) || pg_ext_switch)
 		use_ext_switch = true;
 
 	if (init_hwcfg) {
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/phy.c b/drivers/staging/rtl8821ae/rtl8821ae/phy.c
index 1dd3301..c56936d 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/phy.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/phy.c
@@ -1252,7 +1252,7 @@ static bool _rtl8812ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	for (i = 0; i < arraylength; i += 2) {
 		v1 = ptrarray[i];
 		v2 = (u8) ptrarray[i + 1];
-		if (v1<0xCDCDCDCD) {
+		if (v1 < 0xCDCDCDCD) {
 			rtl_write_byte(rtlpriv, v1, (u8) v2);
 		} else {
 			if (!_rtl8821ae_check_condition(hw,v1)) {
@@ -1296,7 +1296,7 @@ static bool _rtl8821ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 	for (i = 0; i < arraylength; i += 2) {
 		v1 = ptrarray[i];
 		v2 = (u8) ptrarray[i + 1];
-		if (v1<0xCDCDCDCD) {
+		if (v1 < 0xCDCDCDCD) {
 			rtl_write_byte(rtlpriv, v1, (u8) v2);
 			continue;
 		} else {
@@ -1342,7 +1342,7 @@ static bool _rtl8812ae_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 		for (i = 0; i < arraylen; i += 2) {
 			v1 = array_table[i];
 			v2 = array_table[i+1];
-			if (v1<0xCDCDCDCD) {
+			if (v1 < 0xCDCDCDCD) {
 				_rtl8812ae_config_bb_reg(hw, v1, v2);
 				continue;
 			} else {/*This line is the start line of branch.*/
@@ -1431,7 +1431,7 @@ static bool _rtl8821ae_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 		for (i = 0; i < arraylen; i += 2) {
 			v1 = array_table[i];
 			v2 = array_table[i+1];
-			if (v1<0xCDCDCDCD) {
+			if (v1 < 0xCDCDCDCD) {
 				_rtl8821ae_config_bb_reg(hw, v1, v2);
 				continue;
 			} else {/*This line is the start line of branch.*/
@@ -1566,7 +1566,7 @@ static bool _rtl8812ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 			v5 = phy_regarray_table_pg[i+4];
 			v6 = phy_regarray_table_pg[i+5];
 
-			if (v1<0xCDCDCDCD) {
+			if (v1 < 0xCDCDCDCD) {
 				if ( (v4 == 0xfe) || (v4 == 0xffe))
 					mdelay(50);
 				else
@@ -1617,7 +1617,7 @@ static bool _rtl8821ae_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 			v5 = phy_regarray_table_pg[i+4];
 			v6 = phy_regarray_table_pg[i+5];
 
-			if (v1<0xCDCDCDCD) {
+			if (v1 < 0xCDCDCDCD) {
 				if (v4 == 0xfe)
 					mdelay(50);
 				else if (v4 == 0xfd)
@@ -1682,7 +1682,7 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw * hw,
 		for (i = 0; i < radioa_arraylen_a; i = i + 2) {
 			v1 = radioa_array_table_a[i];
 			v2 = radioa_array_table_a[i+1];
-			if (v1<0xcdcdcdcd) {
+			if (v1 < 0xcdcdcdcd) {
 				_rtl8821ae_config_rf_radio_a(hw,v1,v2);
 				continue;
 			}else{/*This line is the start line of branch.*/
@@ -1714,7 +1714,7 @@ bool rtl8812ae_phy_config_rf_with_headerfile(struct ieee80211_hw * hw,
 		for (i = 0; i < radioa_arraylen_b; i = i + 2) {
 			v1 = radioa_array_table_b[i];
 			v2 = radioa_array_table_b[i+1];
-			if (v1<0xcdcdcdcd) {
+			if (v1 < 0xcdcdcdcd) {
 				_rtl8821ae_config_rf_radio_b(hw,v1,v2);
 				continue;
 			}else{/*This line is the start line of branch.*/
@@ -1779,7 +1779,7 @@ bool rtl8821ae_phy_config_rf_with_headerfile(struct ieee80211_hw * hw,
 		for (i = 0; i < radioa_arraylen; i = i + 2) {
 			v1 = radioa_array_table[i];
 			v2 = radioa_array_table[i+1];
-			if (v1<0xcdcdcdcd) {
+			if (v1 < 0xcdcdcdcd) {
 				_rtl8821ae_config_rf_radio_a(hw,v1,v2);
 			}else{/*This line is the start line of branch.*/
 				if(!_rtl8821ae_check_condition(hw,v1)){
diff --git a/drivers/staging/rtl8821ae/rtl8821ae/rf.c b/drivers/staging/rtl8821ae/rtl8821ae/rf.c
index 87c1c97..8662961 100644
--- a/drivers/staging/rtl8821ae/rtl8821ae/rf.c
+++ b/drivers/staging/rtl8821ae/rtl8821ae/rf.c
@@ -211,7 +211,7 @@ static void _rtl8821ae_get_txpower_writeval_by_regulatory(struct ieee80211_hw *h
 			if (rtlphy->pwrgroup_cnt == 1)
 				chnlgroup = 0;
 			else {
-				if(channel<3)
+				if (channel < 3)
 					chnlgroup = 0;
 				else if (channel <6)
 					chnlgroup = 1;
-- 
1.9.1

