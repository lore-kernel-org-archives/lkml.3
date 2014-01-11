Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaAKX4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:56:53 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50572 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaAKX4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:56:45 -0500
Date: Sun, 12 Jan 2014 00:55:43 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Staging: rtl8188eu: Fixed "foo * bar" related coding
 style issues
Message-ID: <b51bc0b23c795b0ffa33cc5a8b5e1d9bb3883137.1389483651.git.t.jp@gmx.de>
References: <cover.1389483651.git.t.jp@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389483651.git.t.jp@gmx.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all "foo * bar", "foo*bar", "foo* bar" checkpatch.pl errors for
rtl8188eu.

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h  |  2 +-
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h |  6 +++---
 drivers/staging/rtl8188eu/include/rtw_ioctl_set.h |  4 ++--
 drivers/staging/rtl8188eu/include/rtw_led.h       |  4 ++--
 drivers/staging/rtl8188eu/include/rtw_mlme.h      |  2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h  | 12 ++++++------
 drivers/staging/rtl8188eu/include/rtw_mp.h        |  8 ++++----
 drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h  |  2 +-
 8 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
index 8d1c37e..161f1e5 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_hal.h
@@ -458,7 +458,7 @@ void Hal_EfuseParseCustomerID88E(struct adapter *padapter, u8 *hwinfo,
 				 bool AutoLoadFail);
 void Hal_ReadAntennaDiversity88E(struct adapter *pAdapter, u8 *PROMContent,
 				 bool AutoLoadFail);
-void Hal_ReadThermalMeter_88E(struct adapter *	dapter, u8 *PROMContent,
+void Hal_ReadThermalMeter_88E(struct adapter *dapter, u8 *PROMContent,
 			      bool AutoloadFail);
 void Hal_EfuseParseXtal_8188E(struct adapter *pAdapter, u8 *hwinfo,
 			      bool AutoLoadFail);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
index 02ccb40..a8facf0 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
@@ -58,11 +58,11 @@ enum rx_packet_type {
 #define INTERRUPT_MSG_FORMAT_LEN 60
 void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *buf);
 s32 rtl8188eu_init_recv_priv(struct adapter *padapter);
-void rtl8188eu_free_recv_priv(struct adapter * padapter);
-void rtl8188eu_recv_hdl(struct adapter * padapter, struct recv_buf *precvbuf);
+void rtl8188eu_free_recv_priv(struct adapter *padapter);
+void rtl8188eu_recv_hdl(struct adapter *padapter, struct recv_buf *precvbuf);
 void rtl8188eu_recv_tasklet(void *priv);
 void rtl8188e_query_rx_phy_status(union recv_frame *fr, struct phy_stat *phy);
-void rtl8188e_process_phy_info(struct adapter * padapter, void *prframe);
+void rtl8188e_process_phy_info(struct adapter *padapter, void *prframe);
 void update_recvframe_phyinfo_88e(union recv_frame *fra, struct phy_stat *phy);
 void update_recvframe_attrib_88e(union recv_frame *fra, struct recv_stat *stat);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
index 49efb23..187fe1f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
+++ b/drivers/staging/rtl8188eu/include/rtw_ioctl_set.h
@@ -28,10 +28,10 @@ typedef u8 NDIS_802_11_PMKID_VALUE[16];
 u8 rtw_set_802_11_add_key(struct adapter *adapt, struct ndis_802_11_key *key);
 u8 rtw_set_802_11_authentication_mode(struct adapter *adapt,
 				      enum ndis_802_11_auth_mode authmode);
-u8 rtw_set_802_11_bssid(struct adapter*adapter, u8 *bssid);
+u8 rtw_set_802_11_bssid(struct adapter *adapter, u8 *bssid);
 u8 rtw_set_802_11_add_wep(struct adapter *adapter, struct ndis_802_11_wep *wep);
 u8 rtw_set_802_11_disassociate(struct adapter *adapter);
-u8 rtw_set_802_11_bssid_list_scan(struct adapter*adapter,
+u8 rtw_set_802_11_bssid_list_scan(struct adapter *adapter,
 				  struct ndis_802_11_ssid *pssid,
 				  int ssid_max_num);
 u8 rtw_set_802_11_infrastructure_mode(struct adapter *adapter,
diff --git a/drivers/staging/rtl8188eu/include/rtw_led.h b/drivers/staging/rtl8188eu/include/rtw_led.h
index 87682cd..0da4e27 100644
--- a/drivers/staging/rtl8188eu/include/rtw_led.h
+++ b/drivers/staging/rtl8188eu/include/rtw_led.h
@@ -182,7 +182,7 @@ struct led_priv{
 void BlinkTimerCallback(void *data);
 void BlinkWorkItemCallback(struct work_struct *work);
 
-void ResetLedStatus(struct LED_871x * pLed);
+void ResetLedStatus(struct LED_871x *pLed);
 
 void InitLed871x(struct adapter *padapter, struct LED_871x *pLed,
 		 enum LED_PIN_871x LedPin);
@@ -190,7 +190,7 @@ void InitLed871x(struct adapter *padapter, struct LED_871x *pLed,
 void DeInitLed871x(struct LED_871x *pLed);
 
 /* hal... */
-void BlinkHandler(struct LED_871x * pLed);
+void BlinkHandler(struct LED_871x *pLed);
 void SwLedOn(struct adapter *padapter, struct LED_871x *pLed);
 void SwLedOff(struct adapter *padapter, struct LED_871x *pLed);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index f1b8233..6cd988f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -614,7 +614,7 @@ void _rtw_free_network_nolock(struct mlme_priv *pmlmepriv,
 			      struct wlan_network *pnetwork);
 
 
-struct wlan_network* _rtw_find_network(struct __queue *scanned_queue, u8 *addr);
+struct wlan_network *_rtw_find_network(struct __queue *scanned_queue, u8 *addr);
 
 void _rtw_free_network_queue(struct adapter *padapter, u8 isfreeall);
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
index 7a4b5c6..f0c982d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme_ext.h
@@ -241,7 +241,7 @@ struct mlme_handler {
 
 struct action_handler {
 	unsigned int   num;
-	char* str;
+	char *str;
 	unsigned int (*func)(struct adapter *adapt, union recv_frame *frame);
 };
 
@@ -484,7 +484,7 @@ void write_cam(struct adapter *padapter, u8 entry, u16 ctrl, u8 *mac, u8 *key);
 void clear_cam_entry(struct adapter *padapter, u8 entry);
 
 void invalidate_cam_all(struct adapter *padapter);
-void CAM_empty_entry(struct adapter * Adapter, u8 ucIndex);
+void CAM_empty_entry(struct adapter *Adapter, u8 ucIndex);
 
 int allocate_fw_sta_entry(struct adapter *padapter);
 void flush_all_cam_entry(struct adapter *padapter);
@@ -548,11 +548,11 @@ void report_survey_event(struct adapter *padapter, union recv_frame *precv_frame
 void report_surveydone_event(struct adapter *padapter);
 void report_del_sta_event(struct adapter *padapter,
 			  unsigned char *addr, unsigned short reason);
-void report_add_sta_event(struct adapter *padapter, unsigned char* addr,
+void report_add_sta_event(struct adapter *padapter, unsigned char *addr,
 			  int cam_idx);
 
 void beacon_timing_control(struct adapter *padapter);
-extern u8 set_tx_beacon_cmd(struct adapter*padapter);
+extern u8 set_tx_beacon_cmd(struct adapter *padapter);
 unsigned int setup_beacon_frame(struct adapter *padapter,
 				unsigned char *beacon_frame);
 void update_mgnt_tx_rate(struct adapter *padapter, u8 rate);
@@ -574,7 +574,7 @@ int issue_probereq_p2p_ex(struct adapter *adapter, u8 *da, int try_cnt,
 			  int wait_ms);
 void issue_p2p_invitation_response(struct adapter *padapter, u8 *raddr,
 				   u8 dialogToken, u8 success);
-void issue_p2p_invitation_request(struct adapter *padapter, u8* raddr);
+void issue_p2p_invitation_request(struct adapter *padapter, u8 *raddr);
 #endif /* CONFIG_88EU_P2P */
 void issue_beacon(struct adapter *padapter, int timeout_ms);
 void issue_probersp(struct adapter *padapter, unsigned char *da,
@@ -587,7 +587,7 @@ void issue_auth(struct adapter *padapter, struct sta_info *psta,
 void issue_probereq(struct adapter *padapter, struct ndis_802_11_ssid *pssid,
 		    u8 *da);
 s32 issue_probereq_ex(struct adapter *adapter, struct ndis_802_11_ssid *pssid,
-		      u8* da, int try_cnt, int wait_ms);
+		      u8 *da, int try_cnt, int wait_ms);
 int issue_nulldata(struct adapter *padapter, unsigned char *da,
 		   unsigned int power_mode, int try_cnt, int wait_ms);
 int issue_qos_nulldata(struct adapter *padapter, unsigned char *da,
diff --git a/drivers/staging/rtl8188eu/include/rtw_mp.h b/drivers/staging/rtl8188eu/include/rtw_mp.h
index 6fea1da..ffa299b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mp.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mp.h
@@ -477,13 +477,13 @@ void Hal_SetChannel(struct adapter *pAdapter);
 void Hal_SetAntennaPathPower(struct adapter *pAdapter);
 s32 Hal_SetThermalMeter(struct adapter *pAdapter, u8 target_ther);
 s32 Hal_SetPowerTracking(struct adapter *padapter, u8 enable);
-void Hal_GetPowerTracking(struct adapter *padapter, u8 * enable);
+void Hal_GetPowerTracking(struct adapter *padapter, u8 *enable);
 void Hal_GetThermalMeter(struct adapter *pAdapter, u8 *value);
 void Hal_mpt_SwitchRfSetting(struct adapter *pAdapter);
-void Hal_MPT_CCKTxPowerAdjust(struct adapter * Adapter, bool bInCH14);
+void Hal_MPT_CCKTxPowerAdjust(struct adapter *Adapter, bool bInCH14);
 void Hal_MPT_CCKTxPowerAdjustbyIndex(struct adapter *pAdapter, bool beven);
-void Hal_SetCCKTxPower(struct adapter *pAdapter, u8 * TxPower);
-void Hal_SetOFDMTxPower(struct adapter *pAdapter, u8 * TxPower);
+void Hal_SetCCKTxPower(struct adapter *pAdapter, u8 *TxPower);
+void Hal_SetOFDMTxPower(struct adapter *pAdapter, u8 *TxPower);
 void Hal_TriggerRFThermalMeter(struct adapter *pAdapter);
 u8 Hal_ReadRFThermalMeter(struct adapter *pAdapter);
 void Hal_SetCCKContinuousTx(struct adapter *pAdapter, u8 bStart);
diff --git a/drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h b/drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
index 494e90e..9388368 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mp_ioctl.h
@@ -278,7 +278,7 @@ struct eeprom_rw_param {
 
 struct mp_ioctl_handler {
 	u32 paramsize;
-	s32 (*handler)(struct oid_par_priv* poid_par_priv);
+	s32 (*handler)(struct oid_par_priv *poid_par_priv);
 	u32 oid;
 };
 
-- 
1.8.5.2

