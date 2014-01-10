Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaAJW7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 17:59:01 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64170 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJW7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 17:59:00 -0500
Date: Fri, 10 Jan 2014 23:57:59 +0100
From: Tim Jester-Pfadt <t.jp@gmx.de>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: rtl8188eu: Fixed whitespace related coding style
 issues
Message-ID: <20140110225759.GA8720@archlinux.uni-trier.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two spaces at the start of the line aswell as all space after
opening parenthesis and space before closeing parenthesis checkpatch.pl warnings
in rtw_mlme.h

Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
---
 drivers/staging/rtl8188eu/include/rtw_mlme.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_mlme.h b/drivers/staging/rtl8188eu/include/rtw_mlme.h
index 33965ca..144f79c 100644
--- a/drivers/staging/rtl8188eu/include/rtw_mlme.h
+++ b/drivers/staging/rtl8188eu/include/rtw_mlme.h
@@ -129,17 +129,17 @@ struct rt_link_detect {
 
 struct profile_info {
 	u8	ssidlen;
-	u8	ssid[ WLAN_SSID_MAXLEN ];
-	u8	peermac[ ETH_ALEN ];
+	u8	ssid[WLAN_SSID_MAXLEN];
+	u8	peermac[ETH_ALEN];
 };
 
 struct tx_invite_req_info {
 	u8	token;
 	u8	benable;
-	u8	go_ssid[ WLAN_SSID_MAXLEN ];
+	u8	go_ssid[WLAN_SSID_MAXLEN];
 	u8	ssidlen;
-	u8	go_bssid[ ETH_ALEN ];
-	u8	peer_macaddr[ ETH_ALEN ];
+	u8	go_bssid[ETH_ALEN];
+	u8	peer_macaddr[ETH_ALEN];
 	u8	operating_ch;	/* This information will be set by using the
 				 * p2p_set op_ch=x */
 	u8	peer_ch;	/* The listen channel for peer P2P device */
@@ -182,9 +182,9 @@ struct tx_nego_req_info {
 };
 
 struct group_id_info {
-	u8	go_device_addr[ ETH_ALEN ];	/* The GO's device address of
+	u8	go_device_addr[ETH_ALEN];	/* The GO's device address of
 						 * this P2P group */
-	u8	ssid[ WLAN_SSID_MAXLEN ];	/* The SSID of this P2P group */
+	u8	ssid[WLAN_SSID_MAXLEN];	/* The SSID of this P2P group */
 };
 
 struct scan_limit_info {
@@ -388,7 +388,7 @@ struct mlme_priv {
 	u8 *assoc_rsp;
 	u32 assoc_rsp_len;
 
-#if defined (CONFIG_88EU_AP_MODE)
+#if defined(CONFIG_88EU_AP_MODE)
 	/* Number of associated Non-ERP stations (i.e., stations using 802.11b
 	 * in 802.11g BSS) */
 	int num_sta_non_erp;
@@ -472,7 +472,7 @@ void rtw_join_timeout_handler(void *FunctionContext);
 void _rtw_scan_timeout_handler(void *FunctionContext);
 void rtw_free_network_queue(struct adapter *adapter, u8 isfreeall);
 int rtw_init_mlme_priv(struct adapter *adapter);
-void rtw_free_mlme_priv (struct mlme_priv *pmlmepriv);
+void rtw_free_mlme_priv(struct mlme_priv *pmlmepriv);
 int rtw_select_and_join_from_scanned_queue(struct mlme_priv *pmlmepriv);
 int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv,
 		int keyid, u8 set_tx);
@@ -572,7 +572,7 @@ struct wlan_network *rtw_get_oldest_wlan_network(struct __queue *scanned_queue);
 void rtw_free_assoc_resources(struct adapter *adapter, int lock_scanned_queue);
 void rtw_indicate_disconnect(struct adapter *adapter);
 void rtw_indicate_connect(struct adapter *adapter);
-void rtw_indicate_scan_done( struct adapter *padapter, bool aborted);
+void rtw_indicate_scan_done(struct adapter *padapter, bool aborted);
 void rtw_scan_abort(struct adapter *adapter);
 
 int rtw_restruct_sec_ie(struct adapter *adapter, u8 *in_ie, u8 *out_ie,
@@ -588,7 +588,7 @@ void rtw_get_encrypt_decrypt_from_registrypriv(struct adapter *adapter);
 void _rtw_join_timeout_handler(struct adapter *adapter);
 void rtw_scan_timeout_handler(struct adapter *adapter);
 
- void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
+void rtw_dynamic_check_timer_handlder(struct adapter *adapter);
 #define rtw_is_scan_deny(adapter) false
 #define rtw_clear_scan_deny(adapter) do {} while (0)
 #define rtw_set_scan_deny_timer_hdl(adapter) do {} while (0)
@@ -605,7 +605,7 @@ int _rtw_enqueue_network(struct __queue *queue, struct wlan_network *pnetwork);
 
 struct wlan_network *_rtw_dequeue_network(struct __queue *queue);
 
- struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
+struct wlan_network *_rtw_alloc_network(struct mlme_priv *pmlmepriv);
 
 
 void _rtw_free_network(struct mlme_priv *pmlmepriv,
-- 
1.8.5.2

