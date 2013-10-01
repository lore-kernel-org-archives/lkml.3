Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3JAP2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:28:21 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:36227 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3JAP2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:28:17 -0400
From: Thomas Cort <linuxgeek@gmail.com>
To: linuxgeek@gmail.com
Cc: linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org
Subject: [PATCH] Staging: rtl8712: fix spaces before semicolons
Date: Tue,  1 Oct 2013 11:26:55 -0400
Message-Id: <1380641215-30902-1-git-send-email-linuxgeek@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolve all of the 'WARNING: space prohibited before semicolon'
checkpatch warnings for rtl8712.

Signed-off-by: Thomas Cort <linuxgeek@gmail.com>
---
 drivers/staging/rtl8712/os_intfs.c            | 2 +-
 drivers/staging/rtl8712/rtl8712_cmd.c         | 4 ++--
 drivers/staging/rtl8712/rtl8712_efuse.c       | 2 +-
 drivers/staging/rtl8712/rtl8712_recv.c        | 6 +++---
 drivers/staging/rtl8712/rtl871x_cmd.c         | 2 +-
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 8 ++++----
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c   | 6 +++---
 drivers/staging/rtl8712/rtl871x_mlme.c        | 4 ++--
 drivers/staging/rtl8712/rtl871x_mp.c          | 8 ++++----
 drivers/staging/rtl8712/rtl871x_security.c    | 6 +++---
 drivers/staging/rtl8712/rtl871x_sta_mgt.c     | 4 ++--
 drivers/staging/rtl8712/xmit_linux.c          | 2 +-
 12 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 6e81ba0..82a77b4 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -141,7 +141,7 @@ static uint loadparam(struct _adapter *padapter, struct  net_device *pnetdev)
 	registry_par->ssid.SsidLength = 3;
 	registry_par->channel = (u8)channel;
 	registry_par->wireless_mode = (u8)wireless_mode;
-	registry_par->vrtl_carrier_sense = (u8)vrtl_carrier_sense ;
+	registry_par->vrtl_carrier_sense = (u8)vrtl_carrier_sense;
 	registry_par->vcs_type = (u8)vcs_type;
 	registry_par->frag_thresh = (u16)frag_thresh;
 	registry_par->preamble = (u8)preamble;
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 088647c..7156826 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -62,7 +62,7 @@ static void check_hw_pbc(struct _adapter *padapter)
 	r8712_write8(padapter, GPIO_IO_SEL, tmp1byte);
 	tmp1byte = r8712_read8(padapter, GPIO_CTRL);
 	if (tmp1byte == 0xff)
-		return ;
+		return;
 	if (tmp1byte&HAL_8192S_HW_GPIO_WPS_BIT) {
 		/* Here we only set bPbcPressed to true
 		 * After trigger PBC, the variable will be set to false */
@@ -381,7 +381,7 @@ _next:
 			*pcmdbuf = cpu_to_le32((cmdsz & 0x0000ffff) |
 					       (pcmd->cmdcode << 16) |
 					       (pcmdpriv->cmd_seq << 24));
-			pcmdbuf += 2 ; /* 8 bytes alignment */
+			pcmdbuf += 2; /* 8 bytes alignment */
 			memcpy((u8 *)pcmdbuf, pcmd->parmbuf, pcmd->cmdsz);
 			while (check_cmd_fifo(padapter, wr_sz) == _FAIL) {
 				if ((padapter->bDriverStopped == true) ||
diff --git a/drivers/staging/rtl8712/rtl8712_efuse.c b/drivers/staging/rtl8712/rtl8712_efuse.c
index 377fca9..c9eeb42 100644
--- a/drivers/staging/rtl8712/rtl8712_efuse.c
+++ b/drivers/staging/rtl8712/rtl8712_efuse.c
@@ -231,7 +231,7 @@ u16 r8712_efuse_get_current_size(struct _adapter *padapter)
 			/* read next header */
 			efuse_addr = efuse_addr + (word_cnts * 2) + 1;
 		} else
-			bContinual = false ;
+			bContinual = false;
 	}
 	return efuse_addr;
 }
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index d59a74a..ea96537 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -108,7 +108,7 @@ void r8712_free_recv_priv(struct recv_priv *precvpriv)
 	struct _adapter *padapter = precvpriv->adapter;
 
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
-	for (i = 0; i < NR_RECVBUFF ; i++) {
+	for (i = 0; i < NR_RECVBUFF; i++) {
 		r8712_os_recvbuf_resource_free(padapter, precvbuf);
 		precvbuf++;
 	}
@@ -268,7 +268,7 @@ union recv_frame *r8712_recvframe_chk_defrag(struct _adapter *padapter,
 	u8   *psta_addr;
 	struct recv_frame_hdr *pfhdr;
 	struct sta_info *psta;
-	struct	sta_priv *pstapriv ;
+	struct	sta_priv *pstapriv;
 	struct list_head *phead;
 	union recv_frame *prtnframe = NULL;
 	struct  __queue *pfree_recv_queue, *pdefrag_q;
@@ -849,7 +849,7 @@ static void query_rx_phy_status(struct _adapter *padapter,
 	} else {
 		/* (1)Get RSSI for HT rate */
 		for (i = 0; i < ((padapter->registrypriv.rf_config) &
-			    0x0f) ; i++) {
+			    0x0f); i++) {
 			rf_rx_num++;
 			rx_pwr[i] = ((pphy_head[PHY_STAT_GAIN_TRSW_SHT + i]
 				    & 0x3F) * 2) - 110;
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index f16307f..7e32431 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -965,7 +965,7 @@ void r8712_createbss_cmd_callback(struct _adapter *padapter,
 			psta = r8712_alloc_stainfo(&padapter->stapriv,
 						   pnetwork->MacAddress);
 			if (psta == NULL)
-				goto createbss_cmd_fail ;
+				goto createbss_cmd_fail;
 		}
 		r8712_indicate_connect(padapter);
 	} else {
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index d58aa7e..9fec6ed 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -820,7 +820,7 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 			intReturn = true;
 		blInserted = false;
 		/* overwrite PMKID */
-		for (j = 0 ; j < NUM_PMKID_CACHE; j++) {
+		for (j = 0; j < NUM_PMKID_CACHE; j++) {
 			if (!memcmp(psecuritypriv->PMKIDList[j].Bssid,
 			    strIssueBssid, ETH_ALEN)) {
 				/* BSSID is matched, the same AP => rewrite
@@ -845,7 +845,7 @@ static int r871x_wx_set_pmkid(struct net_device *dev,
 				PMKIDIndex].PMKID, pPMK->pmkid, IW_PMKID_LEN);
 			psecuritypriv->PMKIDList[psecuritypriv->PMKIDIndex].
 				bUsed = true;
-			psecuritypriv->PMKIDIndex++ ;
+			psecuritypriv->PMKIDIndex++;
 			if (psecuritypriv->PMKIDIndex == NUM_PMKID_CACHE)
 				psecuritypriv->PMKIDIndex = 0;
 		}
@@ -1598,7 +1598,7 @@ static int r8711_wx_set_enc(struct net_device *dev,
 		wep.Length = wep.KeyLength +
 			     FIELD_OFFSET(struct NDIS_802_11_WEP, KeyMaterial);
 	} else {
-		wep.KeyLength = 0 ;
+		wep.KeyLength = 0;
 		if (keyindex_provided == 1) { /* set key_id only, no given
 					       * KeyMaterial(erq->length==0).*/
 			padapter->securitypriv.PrivacyKeyIndex = key;
@@ -1880,7 +1880,7 @@ static int r8711_wx_write32(struct net_device *dev,
 	u32 data32;
 
 	get_user(addr, (u32 __user *)wrqu->data.pointer);
-	data32 = ((u32)wrqu->data.length<<16) | (u32)wrqu->data.flags ;
+	data32 = ((u32)wrqu->data.length<<16) | (u32)wrqu->data.flags;
 	r8712_write32(padapter, addr, data32);
 	return 0;
 }
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
index 5d6d55e..ac0baff 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
@@ -153,7 +153,7 @@ uint oid_rt_get_rx_icv_err_hdl(struct oid_par_priv *poid_par_priv)
 					 padapter->recvpriv.rx_icv_err;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return RNDIS_STATUS_INVALID_LENGTH ;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	return RNDIS_STATUS_SUCCESS;
 }
 
@@ -169,7 +169,7 @@ uint oid_rt_get_preamble_mode_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *padapter = (struct _adapter *)
 				    (poid_par_priv->adapter_context);
-	u32 preamblemode = 0 ;
+	u32 preamblemode = 0;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
 		return RNDIS_STATUS_NOT_ACCEPTED;
@@ -522,7 +522,7 @@ uint oid_rt_get_connect_state_hdl(struct oid_par_priv *poid_par_priv)
 	else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) == true)
 		ulInfo = ADHOCMODE;
 	else
-		ulInfo = NOTASSOCIATED ;
+		ulInfo = NOTASSOCIATED;
 	*(u32 *)poid_par_priv->information_buf = ulInfo;
 	*poid_par_priv->bytes_rw =  poid_par_priv->information_buf_len;
 	return RNDIS_STATUS_SUCCESS;
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index 6596154..8fa0f9d 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -1641,7 +1641,7 @@ void r8712_update_registrypriv_dev_network(struct _adapter *adapter)
 	struct wlan_network	*cur_network = &adapter->mlmepriv.cur_network;
 
 	pdev_network->Privacy = cpu_to_le32(psecuritypriv->PrivacyAlgrthm
-					    > 0 ? 1 : 0) ; /* adhoc no 802.1x */
+					    > 0 ? 1 : 0); /* adhoc no 802.1x */
 	pdev_network->Rssi = 0;
 	switch (pregistrypriv->wireless_mode) {
 	case WIRELESS_11B:
@@ -1786,7 +1786,7 @@ static void update_ht_cap(struct _adapter *padapter, u8 *pie, uint ie_len)
 	psta = r8712_get_stainfo(&padapter->stapriv,
 				 pcur_network->network.MacAddress);
 	if (psta) {
-		for (i = 0; i < 16 ; i++) {
+		for (i = 0; i < 16; i++) {
 			preorder_ctrl = &psta->recvreorder_ctrl[i];
 			preorder_ctrl->indicate_seq = 0xffff;
 			preorder_ctrl->wend_b = 0xffff;
diff --git a/drivers/staging/rtl8712/rtl871x_mp.c b/drivers/staging/rtl8712/rtl871x_mp.c
index 5638d5e..0563318 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.c
+++ b/drivers/staging/rtl8712/rtl871x_mp.c
@@ -110,7 +110,7 @@ static u32 fw_iocmd_read(struct _adapter *pAdapter, struct IOCMD_STRUCT iocmd)
 	u16 iocmd_value	= iocmd.value;
 	u8 iocmd_idx	= iocmd.index;
 
-	cmd32 = (iocmd_class << 24) | (iocmd_value << 8) | iocmd_idx ;
+	cmd32 = (iocmd_class << 24) | (iocmd_value << 8) | iocmd_idx;
 	if (r8712_fw_cmd(pAdapter, cmd32))
 		r8712_fw_cmd_data(pAdapter, &val32, 1);
 	else
@@ -128,7 +128,7 @@ static u8 fw_iocmd_write(struct _adapter *pAdapter,
 
 	r8712_fw_cmd_data(pAdapter, &value, 0);
 	msleep(100);
-	cmd32 = (iocmd_class << 24) | (iocmd_value << 8) | iocmd_idx ;
+	cmd32 = (iocmd_class << 24) | (iocmd_value << 8) | iocmd_idx;
 	return r8712_fw_cmd(pAdapter, cmd32);
 }
 
@@ -189,8 +189,8 @@ u32 r8712_rf_reg_read(struct _adapter *pAdapter, u8 path, u8 offset)
 	u32 rf_data;
 	struct IOCMD_STRUCT iocmd;
 
-	iocmd.cmdclass	= IOCMD_CLASS_BB_RF ;
-	iocmd.value	= rf_addr ;
+	iocmd.cmdclass	= IOCMD_CLASS_BB_RF;
+	iocmd.value	= rf_addr;
 	iocmd.index	= IOCMD_RF_READ_IDX;
 	rf_data = fw_iocmd_read(pAdapter, iocmd);
 	return rf_data;
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index e33fd6d..5349669 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -835,7 +835,7 @@ static void mix_column(u8 *in, u8 *out)
 	u8 temp[4];
 	u8 tempb[4];
 
-	for (i = 0 ; i < 4; i++) {
+	for (i = 0; i < 4; i++) {
 		if ((in[i] & 0x80) == 0x80)
 			add1b[i] = 0x1b;
 		else
@@ -1187,7 +1187,7 @@ u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 					length = pxmitpriv->frag_len -
 						 pattrib->hdrlen -
 						 pattrib->iv_len -
-						 pattrib->icv_len ;
+						 pattrib->icv_len;
 					aes_cipher(prwskey, pattrib->
 						   hdrlen, pframe, length);
 					pframe += pxmitpriv->frag_len;
@@ -1315,7 +1315,7 @@ static sint aes_decipher(u8 *key, uint	hdrlen,
 		bitwise_xor(aes_out, padded_buffer, chain_buffer);
 		aes128k128d(key, chain_buffer, aes_out);
 	}
-	for (j = 0 ; j < 8; j++)
+	for (j = 0; j < 8; j++)
 		mic[j] = aes_out[j];
 	/* Insert MIC into payload */
 	for (j = 0; j < 8; j++)
diff --git a/drivers/staging/rtl8712/rtl871x_sta_mgt.c b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
index 1247b3d..8db6849 100644
--- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -138,7 +138,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 		}
 		phash_list = &(pstapriv->sta_hash[index]);
 		list_insert_tail(&psta->hash_list, phash_list);
-		pstapriv->asoc_sta_count++ ;
+		pstapriv->asoc_sta_count++;
 
 /* For the SMC router, the sequence number of first packet of WPS handshake
  * will be 0. In this case, this packet will be dropped by recv_decache function
@@ -149,7 +149,7 @@ struct sta_info *r8712_alloc_stainfo(struct sta_priv *pstapriv, u8 *hwaddr)
 			memcpy(&psta->sta_recvpriv.rxcache.tid_rxseq[i],
 				&wRxSeqInitialValue, 2);
 		/* for A-MPDU Rx reordering buffer control */
-		for (i = 0; i < 16 ; i++) {
+		for (i = 0; i < 16; i++) {
 			preorder_ctrl = &psta->recvreorder_ctrl[i];
 			preorder_ctrl->padapter = pstapriv->padapter;
 			preorder_ctrl->indicate_seq = 0xffff;
diff --git a/drivers/staging/rtl8712/xmit_linux.c b/drivers/staging/rtl8712/xmit_linux.c
index 4d22bb7..0ac9130 100644
--- a/drivers/staging/rtl8712/xmit_linux.c
+++ b/drivers/staging/rtl8712/xmit_linux.c
@@ -51,7 +51,7 @@ void _r8712_open_pktfile(_pkt *pktptr, struct pkt_file *pfile)
 	pfile->pkt = pktptr;
 	pfile->cur_addr = pfile->buf_start = pktptr->data;
 	pfile->pkt_len = pfile->buf_len = pktptr->len;
-	pfile->cur_buffer = pfile->buf_start ;
+	pfile->cur_buffer = pfile->buf_start;
 }
 
 uint _r8712_pktfile_read(struct pkt_file *pfile, u8 *rmem, uint rlen)
-- 
1.8.1.5

