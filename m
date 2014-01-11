Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbaAKX4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:56:50 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:64907 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaAKX41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:56:27 -0500
Date: Sun, 12 Jan 2014 00:55:25 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Staging: rtl8188eu: Fixed required spaces after ','
 and around '=' and '=='
Message-ID: <e7bd349d1ed1e1782a8830687abc266c54508525.1389483651.git.t.jp@gmx.de>
References: <cover.1389483651.git.t.jp@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389483651.git.t.jp@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all spaces required after ',' and around '=' aswell as '=='
checkpatch.pl errors for rtl8188eu.

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h | 2 +-
 drivers/staging/rtl8188eu/include/odm.h            | 2 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      | 2 +-
 drivers/staging/rtl8188eu/include/odm_interface.h  | 2 +-
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   | 2 +-
 drivers/staging/rtl8188eu/include/rtw_eeprom.h     | 2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h      | 2 +-
 drivers/staging/rtl8188eu/include/rtw_iol.h        | 8 ++++----
 drivers/staging/rtl8188eu/include/rtw_led.h        | 2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme.h       | 6 +++---
 drivers/staging/rtl8188eu/include/rtw_mp.h         | 2 +-
 drivers/staging/rtl8188eu/include/rtw_security.h   | 2 +-
 drivers/staging/rtl8188eu/include/wifi.h           | 2 +-
 13 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h b/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
index 20d0b3e..aebf1d3 100644
--- a/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
+++ b/drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h
@@ -160,7 +160,7 @@
 #define RTL8188E_TRANS_END															\
 	/* format */																\
 	/* { offset, cut_msk, fab_msk|interface_msk, base|cmd, msk, value },  comments here*/					\
-	{0xFFFF, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,0, PWR_CMD_END, 0, 0}, /*  */
+	{0xFFFF, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK, 0, PWR_CMD_END, 0, 0}, /*  */
 
 
 extern struct wl_pwr_cfg rtl8188E_power_on_flow[RTL8188E_TRANS_CARDEMU_TO_ACT_STEPS+RTL8188E_TRANS_END_STEPS];
diff --git a/drivers/staging/rtl8188eu/include/odm.h b/drivers/staging/rtl8188eu/include/odm.h
index 8e9c92c..9d1a79c 100644
--- a/drivers/staging/rtl8188eu/include/odm.h
+++ b/drivers/staging/rtl8188eu/include/odm.h
@@ -151,7 +151,7 @@ struct rtl_ps {
 	int		    Rssi_val_min;
 
 	u8		initialize;
-	u32		Reg874,RegC70,Reg85C,RegA74;
+	u32		Reg874, RegC70, Reg85C, RegA74;
 
 };
 
diff --git a/drivers/staging/rtl8188eu/include/odm_debug.h b/drivers/staging/rtl8188eu/include/odm_debug.h
index c512a4e..e8c4cab 100644
--- a/drivers/staging/rtl8188eu/include/odm_debug.h
+++ b/drivers/staging/rtl8188eu/include/odm_debug.h
@@ -125,7 +125,7 @@
 		DbgPrint(title_str);					\
 		DbgPrint(" ");						\
 		for (__i = 0; __i < 6; __i++)				\
-			DbgPrint("%02X%s", __ptr[__i], (__i==5)?"":"-");\
+			DbgPrint("%02X%s", __ptr[__i], (__i == 5)?"":"-");\
 		DbgPrint("\n");						\
 	}
 
diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index 22f451e..a50eae3 100644
--- a/drivers/staging/rtl8188eu/include/odm_interface.h
+++ b/drivers/staging/rtl8188eu/include/odm_interface.h
@@ -64,7 +64,7 @@ ODM_REG(DIG,_pDM_Odm)
 
 enum odm_h2c_cmd {
 	ODM_H2C_RSSI_REPORT = 0,
-	ODM_H2C_PSD_RESULT= 1,
+	ODM_H2C_PSD_RESULT = 1,
 	ODM_H2C_PathDiv = 2,
 	ODM_MAX_H2CCMD
 };
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 555c801..8d1c37e 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -456,7 +456,7 @@ void rtl8188e_EfuseParseChnlPlan(struct adapter *padapter, u8 *hwinfo,
 				 bool AutoLoadFail);
 void Hal_EfuseParseCustomerID88E(struct adapter *padapter, u8 *hwinfo,
 				 bool AutoLoadFail);
-void Hal_ReadAntennaDiversity88E(struct adapter *pAdapter,u8 *PROMContent,
+void Hal_ReadAntennaDiversity88E(struct adapter *pAdapter, u8 *PROMContent,
 				 bool AutoLoadFail);
 void Hal_ReadThermalMeter_88E(struct adapter *	dapter, u8 *PROMContent,
 			      bool AutoloadFail);
diff --git a/drivers/staging/rtl8188eu/include/rtw_eeprom.h b/drivers/staging/rtl8188eu/include/rtw_eeprom.h
index b2672c3..904fea1 100644
--- a/drivers/staging/rtl8188eu/include/rtw_eeprom.h
+++ b/drivers/staging/rtl8188eu/include/rtw_eeprom.h
@@ -108,7 +108,7 @@ enum RT_CUSTOMER_ID {
 	RT_CID_CC_C = 38,
 	RT_CID_819x_Xavi = 39,
 	RT_CID_819x_FUNAI_TV = 40,
-	RT_CID_819x_ALPHA_WD=41,
+	RT_CID_819x_ALPHA_WD = 41,
 };
 
 struct eeprom_priv {
diff --git a/drivers/staging/rtl8188eu/include/rtw_efuse.h b/drivers/staging/rtl8188eu/include/rtw_efuse.h
index cee6b5e..df51355 100644
--- a/drivers/staging/rtl8188eu/include/rtw_efuse.h
+++ b/drivers/staging/rtl8188eu/include/rtw_efuse.h
@@ -135,7 +135,7 @@ void EFUSE_GetEfuseDefinition(struct adapter *adapt, u8 type, u8 type1,
 u8 efuse_OneByteRead(struct adapter *adapter, u16 addr, u8 *data, bool test);
 u8 efuse_OneByteWrite(struct adapter *adapter, u16 addr, u8 data, bool	test);
 
-void Efuse_PowerSwitch(struct adapter *adapt,u8 bWrite,u8  PwrState);
+void Efuse_PowerSwitch(struct adapter *adapt, u8 bWrite, u8  PwrState);
 int Efuse_PgPacketRead(struct adapter *adapt, u8 offset, u8 *data, bool test);
 int Efuse_PgPacketWrite(struct adapter *adapter, u8 offset, u8 word, u8 *data,
 			bool test);
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index 6949922..ec0c6cb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -70,15 +70,15 @@ int _rtw_IOL_append_WD_cmd(struct xmit_frame *xmit_frame, u16 addr,
 int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path,
 			    u16 addr, u32 value, u32 mask);
 #define rtw_IOL_append_WB_cmd(xmit_frame, addr, value, mask)		\
-	_rtw_IOL_append_WB_cmd((xmit_frame), (addr), (value) ,(mask))
+	_rtw_IOL_append_WB_cmd((xmit_frame), (addr), (value) , (mask))
 #define rtw_IOL_append_WW_cmd(xmit_frame, addr, value, mask)		\
-	_rtw_IOL_append_WW_cmd((xmit_frame), (addr), (value),(mask))
+	_rtw_IOL_append_WW_cmd((xmit_frame), (addr), (value), (mask))
 #define rtw_IOL_append_WD_cmd(xmit_frame, addr, value, mask)		\
 	_rtw_IOL_append_WD_cmd((xmit_frame), (addr), (value), (mask))
 #define rtw_IOL_append_WRF_cmd(xmit_frame, rf_path, addr, value, mask)	\
-	_rtw_IOL_append_WRF_cmd((xmit_frame),(rf_path), (addr), (value), (mask))
+	_rtw_IOL_append_WRF_cmd((xmit_frame), (rf_path), (addr), (value), (mask))
 
 u8 rtw_IOL_cmd_boundary_handle(struct xmit_frame *pxmit_frame);
-void  rtw_IOL_cmd_buf_dump(struct adapter  *Adapter,int buf_len,u8 *pbuf);
+void  rtw_IOL_cmd_buf_dump(struct adapter  *Adapter, int buf_len, u8 *pbuf);
 
 #endif /* __RTW_IOL_H_ */
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index d0da4fd..87682cd 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -147,7 +147,7 @@ struct LED_871x {
 
 enum LED_STRATEGY_871x {
 	SW_LED_MODE0 = 0, /* SW control 1 LED via GPIO0. It is default option.*/
-	SW_LED_MODE1= 1, /*  2 LEDs, through LED0 and LED1. For ALPHA. */
+	SW_LED_MODE1 = 1, /*  2 LEDs, through LED0 and LED1. For ALPHA. */
 	SW_LED_MODE2 = 2, /*  SW control 1 LED via GPIO0, customized for AzWave
 			   * 8187 minicard. */
 	SW_LED_MODE3 = 3, /*  SW control 1 LED via GPIO0, customized for Sercomm
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 144f79c..f1b8233 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -508,7 +508,7 @@ static inline void set_fwstate(struct mlme_priv *pmlmepriv, int state)
 {
 	pmlmepriv->fw_state |= state;
 	/* FOR HW integration */
-	if (_FW_UNDER_SURVEY==state)
+	if (_FW_UNDER_SURVEY == state)
 		pmlmepriv->bScanInProcess = true;
 }
 
@@ -516,7 +516,7 @@ static inline void _clr_fwstate_(struct mlme_priv *pmlmepriv, int state)
 {
 	pmlmepriv->fw_state &= ~state;
 	/* FOR HW integration */
-	if (_FW_UNDER_SURVEY==state)
+	if (_FW_UNDER_SURVEY == state)
 		pmlmepriv->bScanInProcess = false;
 }
 
@@ -640,6 +640,6 @@ int is_same_network(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst);
 void rtw_roaming(struct adapter *padapter, struct wlan_network *tgt_network);
 void _rtw_roaming(struct adapter *padapter, struct wlan_network *tgt_network);
 
-void rtw_stassoc_hw_rpt(struct adapter *adapter,struct sta_info *psta);
+void rtw_stassoc_hw_rpt(struct adapter *adapter, struct sta_info *psta);
 
 #endif /* __RTL871X_MLME_H_ */
diff --git a/drivers/staging/rtl8188eu/include/rtw_mp.h b/drivers/staging/rtl8188eu/include/rtw_mp.h
index 59bdbb5..6fea1da 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mp.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mp.h
@@ -490,6 +490,6 @@ void Hal_SetCCKContinuousTx(struct adapter *pAdapter, u8 bStart);
 void Hal_SetOFDMContinuousTx(struct adapter *pAdapter, u8 bStart);
 void Hal_ProSetCrystalCap (struct adapter *pAdapter , u32 CrystalCapVal);
 void _rtw_mp_xmit_priv(struct xmit_priv *pxmitpriv);
-void MP_PHY_SetRFPathSwitch(struct adapter *pAdapter ,bool bMain);
+void MP_PHY_SetRFPathSwitch(struct adapter *pAdapter , bool bMain);
 
 #endif /* _RTW_MP_H_ */
diff --git a/drivers/staging/rtl8188eu/include/rtw_security.h b/drivers/staging/rtl8188eu/include/rtw_security.h
index 23c7814..937cad8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_security.h
+++ b/drivers/staging/rtl8188eu/include/rtw_security.h
@@ -354,7 +354,7 @@ static const unsigned long K[64] = {
 #define RORc(x, y) \
 	(((((unsigned long)(x) & 0xFFFFFFFFUL) >> (unsigned long)((y)&31)) | \
 	 ((unsigned long)(x) << (unsigned long)(32-((y)&31)))) & 0xFFFFFFFFUL)
-#define Ch(x, y ,z)       (z ^ (x & (y ^ z)))
+#define Ch(x, y , z)       (z ^ (x & (y ^ z)))
 #define Maj(x, y, z)      (((x | y) & z) | (x & y))
 #define S(x, n)         RORc((x), (n))
 #define R(x, n)         (((x)&0xFFFFFFFFUL)>>(n))
diff --git a/drivers/staging/rtl8188eu/include/wifi.h b/drivers/staging/rtl8188eu/include/wifi.h
index 84e5199..2e7307f 100644
--- a/drivers/staging/rtl8188eu/include/wifi.h
+++ b/drivers/staging/rtl8188eu/include/wifi.h
@@ -1080,7 +1080,7 @@ enum P2P_PROTO_WK_ID {
 	P2P_PRE_TX_PROVDISC_PROCESS_WK = 2,
 	P2P_PRE_TX_NEGOREQ_PROCESS_WK = 3,
 	P2P_PRE_TX_INVITEREQ_PROCESS_WK = 4,
-	P2P_AP_P2P_CH_SWITCH_PROCESS_WK =5,
+	P2P_AP_P2P_CH_SWITCH_PROCESS_WK = 5,
 	P2P_RO_CH_WK = 6,
 };
 
-- 
1.8.5.2

