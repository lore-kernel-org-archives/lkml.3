Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaAIUih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:38:37 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60555 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaAIUi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:38:27 -0500
Date: Thu, 9 Jan 2014 21:37:29 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Staging: rtl8188eu: Fixed required spaces after ',' and
 around '=' and '=='
Message-ID: <a4a300dc6d12cecfcf1a33a1e26b7ca94d9f3ca2.1389295303.git.t.jp@gmx.de>
References: <cover.1389295303.git.t.jp@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389295303.git.t.jp@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all spaces required after ',' and around '=' aswell as '=='
checkpatch.pl errors for rtl8188eu.

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/include/Hal8188EPwrSeq.h |  2 +-
 drivers/staging/rtl8188eu/include/odm.h            |  2 +-
 drivers/staging/rtl8188eu/include/odm_debug.h      |  2 +-
 drivers/staging/rtl8188eu/include/odm_interface.h  |  2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h  | 22 ++++++++--------
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |  2 +-
 drivers/staging/rtl8188eu/include/rtw_cmd.h        |  4 +--
 drivers/staging/rtl8188eu/include/rtw_eeprom.h     |  2 +-
 drivers/staging/rtl8188eu/include/rtw_efuse.h      |  2 +-
 drivers/staging/rtl8188eu/include/rtw_io.h         | 30 +++++++++++-----------
 drivers/staging/rtl8188eu/include/rtw_iol.h        |  8 +++---
 drivers/staging/rtl8188eu/include/rtw_led.h        |  2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme.h       |  6 ++---
 drivers/staging/rtl8188eu/include/rtw_mp.h         |  2 +-
 drivers/staging/rtl8188eu/include/rtw_security.h   |  2 +-
 drivers/staging/rtl8188eu/include/wifi.h           |  2 +-
 16 files changed, 46 insertions(+), 46 deletions(-)

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
index eaa4bc1..80d9815 100644
--- a/drivers/staging/rtl8188eu/include/odm.h
+++ b/drivers/staging/rtl8188eu/include/odm.h
@@ -151,7 +151,7 @@ struct rtl_ps {
 	int		    Rssi_val_min;
 
 	u8		initialize;
-	u32		Reg874,RegC70,Reg85C,RegA74;
+	u32		Reg874, RegC70, Reg85C, RegA74;
 
 };
 
diff --git a/drivers/staging/rtl8188eu/include/odm_debug.h b/drivers/staging/rtl8188eu/include/odm_debug.h
index 622f4c1..bd16c84 100644
--- a/drivers/staging/rtl8188eu/include/odm_debug.h
+++ b/drivers/staging/rtl8188eu/include/odm_debug.h
@@ -136,7 +136,7 @@
 		DbgPrint(title_str);					\
 		DbgPrint(" ");						\
 		for (__i = 0; __i < 6; __i++)				\
-			DbgPrint("%02X%s", __ptr[__i], (__i==5)?"":"-");\
+			DbgPrint("%02X%s", __ptr[__i], (__i == 5)?"":"-");\
 		DbgPrint("\n");						\
 	}
 
diff --git a/drivers/staging/rtl8188eu/include/odm_interface.h b/drivers/staging/rtl8188eu/include/odm_interface.h
index e5c8704..d25eb08 100644
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
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 36523ed..715d0a7 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -129,22 +129,22 @@ static inline void rtw_list_delete(struct list_head *plist)
 	list_del_init(plist);
 }
 
-static inline void _init_timer(struct timer_list *ptimer,struct  net_device *nic_hdl,void *pfunc,void* cntx)
+static inline void _init_timer(struct timer_list *ptimer, struct  net_device *nic_hdl, void *pfunc, void* cntx)
 {
 	ptimer->function = pfunc;
 	ptimer->data = (unsigned long)cntx;
 	init_timer(ptimer);
 }
 
-static inline void _set_timer(struct timer_list *ptimer,u32 delay_time)
+static inline void _set_timer(struct timer_list *ptimer, u32 delay_time)
 {
 	mod_timer(ptimer , (jiffies+(delay_time*HZ/1000)));
 }
 
-static inline void _cancel_timer(struct timer_list *ptimer,u8 *bcancelled)
+static inline void _cancel_timer(struct timer_list *ptimer, u8 *bcancelled)
 {
 	del_timer_sync(ptimer);
-	*bcancelled=  true;/* true ==1; false==0 */
+	*bcancelled = true;/* true ==1; false==0 */
 }
 
 #define RTW_TIMER_HDL_ARGS void *FunctionContext
@@ -357,13 +357,13 @@ static inline int res_to_status(int res)
 }
 
 #define _RND(sz, r) ((((sz)+((r)-1))/(r))*(r))
-#define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0: 1)) << 2)
+#define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0 : 1)) << 2)
 
 static inline u32 _RND4(u32 sz)
 {
 	u32	val;
 
-	val = ((sz >> 2) + ((sz & 3) ? 1: 0)) << 2;
+	val = ((sz >> 2) + ((sz & 3) ? 1 : 0)) << 2;
 	return val;
 }
 
@@ -371,7 +371,7 @@ static inline u32 _RND8(u32 sz)
 {
 	u32	val;
 
-	val = ((sz >> 3) + ((sz & 7) ? 1: 0)) << 3;
+	val = ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
 	return val;
 }
 
@@ -379,7 +379,7 @@ static inline u32 _RND128(u32 sz)
 {
 	u32	val;
 
-	val = ((sz >> 7) + ((sz & 127) ? 1: 0)) << 7;
+	val = ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
 	return val;
 }
 
@@ -387,7 +387,7 @@ static inline u32 _RND256(u32 sz)
 {
 	u32	val;
 
-	val = ((sz >> 8) + ((sz & 255) ? 1: 0)) << 8;
+	val = ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
 	return val;
 }
 
@@ -395,7 +395,7 @@ static inline u32 _RND512(u32 sz)
 {
 	u32	val;
 
-	val = ((sz >> 9) + ((sz & 511) ? 1: 0)) << 9;
+	val = ((sz >> 9) + ((sz & 511) ? 1 : 0)) << 9;
 	return val;
 }
 
@@ -451,7 +451,7 @@ void rtw_free_netdev(struct net_device *netdev);
 #define FUNC_ADPT_FMT "%s(%s)"
 #define FUNC_ADPT_ARG(adapter) __func__, adapter->pnetdev->name
 
-#define rtw_signal_process(pid, sig) kill_pid(find_vpid((pid)),(sig), 1)
+#define rtw_signal_process(pid, sig) kill_pid(find_vpid((pid)), (sig), 1)
 
 u64 rtw_modular64(u64 x, u64 y);
 u64 rtw_division64(u64 x, u64 y);
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
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index 8cafd7a..71ea553 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -787,7 +787,7 @@ u8 rtw_setrfintfs_cmd(struct adapter  *padapter, u8 mode);
 u8 rtw_setrttbl_cmd(struct adapter  *padapter, struct setratable_parm *prate_table);
 u8 rtw_getrttbl_cmd(struct adapter  *padapter, struct getratable_rsp *pval);
 
-u8 rtw_gettssi_cmd(struct adapter  *padapter, u8 offset,u8 *pval);
+u8 rtw_gettssi_cmd(struct adapter  *padapter, u8 offset, u8 *pval);
 u8 rtw_setfwdig_cmd(struct adapter*padapter, u8 type);
 u8 rtw_setfwra_cmd(struct adapter*padapter, u8 type);
 
@@ -798,7 +798,7 @@ u8 rtw_dynamic_chk_wk_cmd(struct adapter *adapter);
 u8 rtw_lps_ctrl_wk_cmd(struct adapter*padapter, u8 lps_ctrl_type, u8 enqueue);
 u8 rtw_rpt_timer_cfg_cmd(struct adapter*padapter, u16 minRptTime);
 
- u8 rtw_antenna_select_cmd(struct adapter*padapter, u8 antenna,u8 enqueue);
+u8 rtw_antenna_select_cmd(struct adapter*padapter, u8 antenna, u8 enqueue);
 u8 rtw_ps_cmd(struct adapter*padapter);
 
 #ifdef CONFIG_88EU_AP_MODE
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
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index eb6f0e5..234d705 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -123,7 +123,7 @@ struct _io_ops {
 			  u8 *pmem);
 	u32 (*_write_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
-	u32 (*_write_scsi)(struct intf_hdl *pintfhdl,u32 cnt, u8 *pmem);
+	u32 (*_write_scsi)(struct intf_hdl *pintfhdl, u32 cnt, u8 *pmem);
 	void (*_read_port_cancel)(struct intf_hdl *pintfhdl);
 	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
 };
@@ -254,7 +254,7 @@ struct io_priv {
 };
 
 uint ioreq_flush(struct adapter *adapter, struct io_queue *ioqueue);
-void sync_ioreq_enqueue(struct io_req *preq,struct io_queue *ioqueue);
+void sync_ioreq_enqueue(struct io_req *preq, struct io_queue *ioqueue);
 uint sync_ioreq_flush(struct adapter *adapter, struct io_queue *ioqueue);
 uint free_ioreq(struct io_req *preq, struct io_queue *pio_queue);
 struct io_req *alloc_ioreq(struct io_queue *pio_q);
@@ -370,18 +370,18 @@ void bus_sync_io(struct io_queue *pio_q);
 u32 _ioreq2rwmem(struct io_queue *pio_q);
 void dev_power_down(struct adapter * Adapter, u8 bpwrup);
 
-#define PlatformEFIOWrite1Byte(_a,_b,_c)		\
-	rtw_write8(_a,_b,_c)
-#define PlatformEFIOWrite2Byte(_a,_b,_c)		\
-	rtw_write16(_a,_b,_c)
-#define PlatformEFIOWrite4Byte(_a,_b,_c)		\
-	rtw_write32(_a,_b,_c)
-
-#define PlatformEFIORead1Byte(_a,_b)		\
-		rtw_read8(_a,_b)
-#define PlatformEFIORead2Byte(_a,_b)		\
-		rtw_read16(_a,_b)
-#define PlatformEFIORead4Byte(_a,_b)		\
-		rtw_read32(_a,_b)
+#define PlatformEFIOWrite1Byte(_a, _b, _c)		\
+	rtw_write8(_a , _b, _c)
+#define PlatformEFIOWrite2Byte(_a, _b, _c)		\
+	rtw_write16(_a, _b, _c)
+#define PlatformEFIOWrite4Byte(_a, _b, _c)		\
+	rtw_write32(_a, _b, _c)
+
+#define PlatformEFIORead1Byte(_a, _b)		\
+		rtw_read8(_a, _b)
+#define PlatformEFIORead2Byte(_a, _b)		\
+		rtw_read16(_a, _b)
+#define PlatformEFIORead4Byte(_a, _b)		\
+		rtw_read32(_a, _b)
 
 #endif	/* _RTL8711_IO_H_ */
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
index 4a7143e..b548833 100644
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
 
@@ -650,6 +650,6 @@ int is_same_network(struct wlan_bssid_ex *src, struct wlan_bssid_ex *dst);
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

