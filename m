Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaHVK3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:29:07 -0400
Received: from [207.46.163.142] ([207.46.163.142]:5851 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752166AbaHVK3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:29:04 -0400
From: Matthew Casey <mdcasey@chabloom.com>
To: <gregkh@linuxfoundation.org>
CC: <Larry.Finger@lwfinger.net>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Matthew Casey <mdcasey@chabloom.com>
Subject: [PATCH] staging: rtl8192e: fixed coding style issues
Date: Fri, 22 Aug 2014 06:27:52 -0400
Message-ID: <1408703272-15984-1-git-send-email-mdcasey@chabloom.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [72.28.182.130]
X-ClientProxiedBy: CO2PR04CA016.namprd04.prod.outlook.com (10.141.240.144) To
 DM2PR03MB591.namprd03.prod.outlook.com (10.141.85.27)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(199003)(77982001)(46102001)(36756003)(95666004)(48376002)(69596002)(33646002)(81156004)(79102001)(107046002)(2351001)(90102001)(76482001)(77156001)(50466002)(81342001)(106356001)(105586002)(88136002)(64706001)(31966008)(81542001)(85306004)(50226001)(229853001)(21056001)(74502001)(104166001)(93916002)(74662001)(89996001)(92566001)(20776003)(575784001)(77096002)(83072002)(110136001)(50986999)(86362001)(83322001)(102836001)(87286001)(4396001)(53416004)(66066001)(92726001)(19580395003)(85852003)(47776003)(19580405001)(62966002)(80022001)(101416001)(87976001)(42186005)(99396002)(579004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB591;H:linux-pd0.atlanticbb.net;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:;
X-OriginatorOrg: chabloom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed missing blank line after declarations issues

Signed-off-by: Matthew Casey <mdcasey@chabloom.com>
---
 drivers/staging/rtl8192e/dot11d.c                  |  1 +
 drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c |  1 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     | 16 +++++++++++++++
 .../staging/rtl8192e/rtl8192e/r8192E_firmware.c    |  1 +
 drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c     |  8 ++++++++
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c        |  4 ++++
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       | 15 ++++++++++++++
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c         | 15 ++++++++++++++
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.c         |  8 +++++++-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c         |  8 ++++++++
 drivers/staging/rtl8192e/rtl819x_BAProc.c          |  5 +++++
 drivers/staging/rtl8192e/rtl819x_HTProc.c          |  7 +++++++
 drivers/staging/rtl8192e/rtl819x_TSProc.c          |  6 ++++++
 drivers/staging/rtl8192e/rtllib.h                  |  1 +
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c       |  3 +++
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c       |  5 +++++
 drivers/staging/rtl8192e/rtllib_crypt_wep.c        |  4 ++++
 drivers/staging/rtl8192e/rtllib_module.c           |  1 +
 drivers/staging/rtl8192e/rtllib_rx.c               | 10 ++++++++++
 drivers/staging/rtl8192e/rtllib_softmac.c          | 23 ++++++++++++++++++++--
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |  1 +
 drivers/staging/rtl8192e/rtllib_tx.c               |  4 ++++
 drivers/staging/rtl8192e/rtllib_wx.c               |  5 +++++
 23 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/dot11d.c b/drivers/staging/rtl8192e/dot11d.c
index bfcc935..ef9da86 100644
--- a/drivers/staging/rtl8192e/dot11d.c
+++ b/drivers/staging/rtl8192e/dot11d.c
@@ -49,6 +49,7 @@ static struct channel_list ChannelPlan[] = {
 void dot11d_init(struct rtllib_device *ieee)
 {
 	struct rt_dot11d_info *pDot11dInfo = GET_DOT11D_INFO(ieee);
+
 	pDot11dInfo->bEnabled = false;
 
 	pDot11dInfo->State = DOT11D_STATE_NONE;
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c b/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c
index 5af1c19..f0b150f 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8190P_rtl8256.c
@@ -86,6 +86,7 @@ bool PHY_RF8256_Config(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	bool rtStatus = true;
+
 	priv->NumTotalRFPath = RTL819X_TOTAL_RF_PATH;
 	rtStatus = phy_RF8256_Config_ParaFile(dev);
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 4a35f9b..0ffed2d 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -62,6 +62,7 @@ static void rtl8192e_update_msr(struct net_device *dev)
 	struct r8192_priv *priv = rtllib_priv(dev);
 	u8 msr;
 	enum led_ctl_mode LedAction = LED_CTL_NO_LINK;
+
 	msr  = read_nic_byte(dev, MSR);
 	msr &= ~MSR_LINK_MASK;
 
@@ -166,6 +167,7 @@ void rtl8192e_SetHwReg(struct net_device *dev, u8 variable, u8 *val)
 	case HW_VAR_ACK_PREAMBLE:
 	{
 		u32 regTmp;
+
 		priv->short_preamble = (bool)(*(u8 *)val);
 		regTmp = priv->basic_rate;
 		if (priv->short_preamble)
@@ -299,6 +301,7 @@ void rtl8192e_SetHwReg(struct net_device *dev, u8 variable, u8 *val)
 	case HW_VAR_RF_TIMING:
 	{
 		u8 Rf_Timing = *((u8 *)val);
+
 		write_nic_byte(dev, rFPGA0_RFTiming1, Rf_Timing);
 		break;
 	}
@@ -318,6 +321,7 @@ static void rtl8192_read_eeprom_info(struct net_device *dev)
 	u16 i, usValue, IC_Version;
 	u16 EEPROMId;
 	u8 bMac_Tmp_Addr[6] = {0x00, 0xe0, 0x4c, 0x00, 0x00, 0x01};
+
 	RT_TRACE(COMP_INIT, "====> rtl8192_read_eeprom_info\n");
 
 	EEPROMId = eprom_read(dev, 0);
@@ -682,6 +686,7 @@ static void rtl8192_hwconfig(struct net_device *dev)
 	write_nic_byte(dev, BW_OPMODE, regBwOpMode);
 	{
 		u32 ratr_value = 0;
+
 		ratr_value = regRATR;
 		if (priv->rf_type == RF_1T2R)
 			ratr_value &= ~(RATE_ALL_OFDM_2SS);
@@ -807,6 +812,7 @@ start:
 	CamResetAllEntry(dev);
 	{
 		u8 SECR_value = 0x0;
+
 		SECR_value |= SCR_TxEncEnable;
 		SECR_value |= SCR_RxDecEnable;
 		SECR_value |= SCR_NoSKMC;
@@ -816,6 +822,7 @@ start:
 	write_nic_word(dev, BCN_INTERVAL, 100);
 	{
 		int i;
+
 		for (i = 0; i < QOS_QUEUE_NUM; i++)
 			write_nic_dword(dev, WDCAPARA_ADD[i], 0x005e4332);
 	}
@@ -1003,6 +1010,7 @@ void rtl8192_link_change(struct net_device *dev)
 
 	if (ieee->iw_mode == IW_MODE_INFRA || ieee->iw_mode == IW_MODE_ADHOC) {
 		u32 reg = 0;
+
 		reg = read_nic_dword(dev, RCR);
 		if (priv->rtllib->state == RTLLIB_LINKED) {
 			if (ieee->IntelPromiscuousModeInfo.bPromiscuousOn)
@@ -1175,6 +1183,7 @@ void  rtl8192_tx_fill_desc(struct net_device *dev, struct tx_desc *pdesc,
 	dma_addr_t mapping = pci_map_single(priv->pdev, skb->data, skb->len,
 			 PCI_DMA_TODEVICE);
 	struct tx_fwinfo_8190pci *pTxFwInfo = NULL;
+
 	pTxFwInfo = (struct tx_fwinfo_8190pci *)skb->data;
 	memset(pTxFwInfo, 0, sizeof(struct tx_fwinfo_8190pci));
 	pTxFwInfo->TxHT = (cb_desc->data_rate & 0x80) ? 1 : 0;
@@ -1233,6 +1242,7 @@ void  rtl8192_tx_fill_desc(struct net_device *dev, struct tx_desc *pdesc,
 	pdesc->SecType = 0x0;
 	if (cb_desc->bHwSec) {
 		static u8 tmp;
+
 		if (!tmp) {
 			RT_TRACE(COMP_DBG, "==>================hw sec\n");
 			tmp = 1;
@@ -1293,6 +1303,7 @@ void  rtl8192_tx_fill_cmd_desc(struct net_device *dev,
 		entry->CmdInit = DESC_PACKET_TYPE_INIT;
 	} else {
 		struct tx_desc * entry_tmp = (struct tx_desc *)entry;
+
 		entry_tmp->CmdInit = DESC_PACKET_TYPE_NORMAL;
 		entry_tmp->Offset = sizeof(struct tx_fwinfo_8190pci) + 8;
 		entry_tmp->PktSize = (u16)(cb_desc->pkt_size +
@@ -2031,6 +2042,7 @@ bool rtl8192_rx_query_status_desc(struct net_device *dev,
 		return false;
 	} else {
 		struct rx_fwinfo *pDrvInfo = NULL;
+
 		stats->RxDrvInfoSize = pdesc->RxDrvInfoSize;
 		stats->RxBufShift = ((pdesc->Shift)&0x03);
 		stats->Decrypted = !pdesc->SWDec;
@@ -2220,6 +2232,7 @@ rtl8192_InitializeVariables(struct net_device  *dev)
 void rtl8192_EnableInterrupt(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	priv->irq_enabled = 1;
 
 	write_nic_dword(dev, INTA_MASK, priv->irq_mask[0]);
@@ -2238,6 +2251,7 @@ void rtl8192_DisableInterrupt(struct net_device *dev)
 void rtl8192_ClearInterrupt(struct net_device *dev)
 {
 	u32 tmp = 0;
+
 	tmp = read_nic_dword(dev, ISR);
 	write_nic_dword(dev, ISR, tmp);
 }
@@ -2246,6 +2260,7 @@ void rtl8192_ClearInterrupt(struct net_device *dev)
 void rtl8192_enable_rx(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	write_nic_dword(dev, RDQDA, priv->rx_ring_dma[RX_MPDU_QUEUE]);
 }
 
@@ -2358,6 +2373,7 @@ bool rtl8192_GetNmodeSupportBySecCfg(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
+
 	if (ieee->rtllib_ap_sec_type &&
 	   (ieee->rtllib_ap_sec_type(priv->rtllib)&(SEC_ALG_WEP |
 				     SEC_ALG_TKIP))) {
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
index 1a95d1f..2e28744 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
@@ -261,6 +261,7 @@ bool init_firmware(struct net_device *dev)
 				};
 				const struct firmware *fw_entry;
 				int rc;
+
 				rc = request_firmware(&fw_entry,
 						      fw_name[init_step],
 						      &priv->pdev->dev);
diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
index 8848921..f1a9f1e 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
@@ -56,6 +56,7 @@ static void phy_FwRFSerialWrite(struct net_device *dev,
 static u32 rtl8192_CalculateBitShift(u32 dwBitMask)
 {
 	u32 i;
+
 	for (i = 0; i <= 31; i++) {
 		if (((dwBitMask >> i) & 0x1) == 1)
 			break;
@@ -67,6 +68,7 @@ u8 rtl8192_phy_CheckIsLegalRFPath(struct net_device *dev, u32 eRFPath)
 {
 	u8 ret = 1;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (priv->rf_type == RF_2T4R)
 		ret = 0;
 	else if (priv->rf_type == RF_1T2R) {
@@ -112,6 +114,7 @@ static u32 rtl8192_phy_RFSerialRead(struct net_device *dev,
 	u32 ret = 0;
 	u32 NewOffset = 0;
 	struct bb_reg_definition *pPhyReg = &priv->PHYRegDef[eRFPath];
+
 	Offset &= 0x3f;
 
 	if (priv->rf_chip == RF_8256) {
@@ -261,6 +264,7 @@ u32 rtl8192_phy_QueryRFReg(struct net_device *dev, enum rf90_radio_path eRFPath,
 {
 	u32 Original_Value, Readback_Value, BitShift;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (!rtl8192_phy_CheckIsLegalRFPath(dev, eRFPath))
 		return 0;
 	if (priv->rtllib->eRFPowerState != eRfOn && !priv->being_init_adapter)
@@ -285,6 +289,7 @@ static u32 phy_FwRFSerialRead(struct net_device *dev,
 	u32		retValue = 0;
 	u32		Data = 0;
 	u8		time = 0;
+
 	Data |= ((Offset & 0xFF) << 12);
 	Data |= ((eRFPath & 0x3) << 20);
 	Data |= 0x80000000;
@@ -700,6 +705,7 @@ bool rtl8192_phy_RFConfig(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	bool rtStatus = true;
+
 	switch (priv->rf_chip) {
 	case RF_8225:
 		break;
@@ -1018,6 +1024,7 @@ void rtl8192_SwChnl_WorkItem(struct net_device *dev)
 u8 rtl8192_phy_SwChnl(struct net_device *dev, u8 channel)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	RT_TRACE(COMP_PHY, "=====>%s()\n", __func__);
 	if (IS_NIC_DOWN(priv)) {
 		RT_TRACE(COMP_ERR, "%s(): ERR !! driver is not up\n", __func__);
@@ -1438,6 +1445,7 @@ static bool SetRFPowerState8190(struct net_device *dev,
 			     RT_IN_PS_LEVEL(pPSC, RT_RF_OFF_LEVL_HALT_NIC)) {
 				bool rtstatus = true;
 				u32 InitilizeCount = 3;
+
 				do {
 					InitilizeCount--;
 					priv->RegRfOff = false;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
index c46c65c..6c64e08 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_cam.c
@@ -53,6 +53,7 @@ void EnableHWSecurityConfig8192(struct net_device *dev)
 	u8 SECR_value = 0x0;
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
+
 	SECR_value = SCR_TxEncEnable | SCR_RxDecEnable;
 	if (((KEY_TYPE_WEP40 == ieee->pairwise_key_type) ||
 	     (KEY_TYPE_WEP104 == ieee->pairwise_key_type)) &&
@@ -84,6 +85,7 @@ void set_swcam(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
+
 	RT_TRACE(COMP_DBG, "===========>%s():EntryNo is %d,KeyIndex is "
 		 "%d,KeyType is %d,is_mesh is %d\n", __func__, EntryNo,
 		 KeyIndex, KeyType, is_mesh);
@@ -106,6 +108,7 @@ void setKey(struct net_device *dev, u8 EntryNo, u8 KeyIndex, u16 KeyType,
 	u8 i;
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
 	enum rt_rf_power_state rtState;
+
 	rtState = priv->rtllib->eRFPowerState;
 	if (priv->rtllib->PowerSaveControl.bInactivePs) {
 		if (rtState == eRfOff) {
@@ -171,6 +174,7 @@ void CAM_read_entry(struct net_device *dev, u32 iIndex)
 	u8 entry_i = 0;
 	u32 ulStatus;
 	s32 i = 100;
+
 	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
 		target_command = entry_i+CAM_CONTENT_COUNT*iIndex;
 		target_command = target_command | BIT31;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 5729cf6..129447c 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -325,6 +325,7 @@ bool MgntActSet_RF_State(struct net_device *dev,
 	enum rt_rf_power_state rtState;
 	u16			RFWaitCounter = 0;
 	unsigned long flag;
+
 	RT_TRACE((COMP_PS | COMP_RF), "===>MgntActSet_RF_State(): "
 		 "StateToSet(%d)\n", StateToSet);
 
@@ -486,6 +487,7 @@ void rtl8192_tx_timeout(struct net_device *dev)
 void rtl8192_irq_enable(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	priv->irq_enabled = 1;
 
 	priv->ops->irq_enable(dev);
@@ -717,6 +719,7 @@ static int rtl8192_handle_assoc_response(struct net_device *dev,
 				 struct rtllib_network *network)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	rtl8192_qos_association_resp(priv, network);
 	return 0;
 }
@@ -762,6 +765,7 @@ void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_network *net;
 	u8 i = 0, basic_rate = 0;
+
 	net = &priv->rtllib->current_network;
 
 	for (i = 0; i < net->rates_len; i++) {
@@ -852,6 +856,7 @@ void rtl8192_config_rate(struct net_device *dev, u16 *rate_config)
 static void rtl8192_refresh_supportrate(struct r8192_priv *priv)
 {
 	struct rtllib_device *ieee = priv->rtllib;
+
 	if (ieee->mode == WIRELESS_MODE_N_24G ||
 	    ieee->mode == WIRELESS_MODE_N_5G) {
 		memcpy(ieee->Regdot11HTOperationalRateSet,
@@ -941,6 +946,7 @@ static int _rtl8192_sta_up(struct net_device *dev, bool is_silent_reset)
 	struct rt_pwr_save_ctrl *pPSC = (struct rt_pwr_save_ctrl *)
 					(&(priv->rtllib->PowerSaveControl));
 	bool init_status = true;
+
 	priv->bDriverIsGoingToUnload = false;
 	priv->bdisable_nic = false;
 
@@ -1270,6 +1276,7 @@ static short rtl8192_get_channel_map(struct net_device *dev)
 	int i;
 
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if ((priv->rf_chip != RF_8225) && (priv->rf_chip != RF_8256)
 			&& (priv->rf_chip != RF_6052)) {
 		RT_TRACE(COMP_ERR, "%s: unknown rf chip, can't set channel "
@@ -1346,6 +1353,7 @@ short rtl8192_is_tx_queue_empty(struct net_device *dev)
 {
 	int i = 0;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	for (i = 0; i <= MGNT_QUEUE; i++) {
 		if ((i == TXCMD_QUEUE) || (i == HCCA_QUEUE))
 			continue;
@@ -1783,6 +1791,7 @@ void	rtl819x_watchdog_wqcallback(void *data)
 void watch_dog_timer_callback(unsigned long data)
 {
 	struct r8192_priv *priv = rtllib_priv((struct net_device *)data);
+
 	queue_delayed_work_rsl(priv->priv_wq, &priv->watch_dog_wq, 0);
 	mod_timer(&priv->watch_dog_timer, jiffies +
 		  MSECS(RTLLIB_WATCH_DOG_TIME));
@@ -1794,6 +1803,7 @@ void watch_dog_timer_callback(unsigned long data)
 void rtl8192_rx_enable(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	priv->ops->rx_enable(dev);
 }
 
@@ -1816,6 +1826,7 @@ static void rtl8192_free_rx_ring(struct net_device *dev)
 	     rx_queue_idx++) {
 		for (i = 0; i < priv->rxringcount; i++) {
 			struct sk_buff *skb = priv->rx_buf[rx_queue_idx][i];
+
 			if (!skb)
 				continue;
 
@@ -2080,6 +2091,7 @@ static short rtl8192_alloc_rx_desc_ring(struct net_device *dev)
 		for (i = 0; i < priv->rxringcount; i++) {
 			struct sk_buff *skb = dev_alloc_skb(priv->rxbuffersize);
 			dma_addr_t *mapping;
+
 			entry = &priv->rx_ring[rx_queue_idx][i];
 			if (!skb)
 				return 0;
@@ -2171,6 +2183,7 @@ void rtl8192_pci_resetdescring(struct net_device *dev)
 	for (rx_queue_idx = 0; rx_queue_idx < MAX_RX_QUEUE; rx_queue_idx++) {
 		if (priv->rx_ring[rx_queue_idx]) {
 			struct rx_desc *entry = NULL;
+
 			for (i = 0; i < priv->rxringcount; i++) {
 				entry = &priv->rx_ring[rx_queue_idx][i];
 				entry->OWN = 1;
@@ -2691,6 +2704,7 @@ static irqreturn_t rtl8192_interrupt(int irq, void *netdev)
 	unsigned long flags;
 	u32 inta;
 	u32 intb;
+
 	intb = 0;
 
 	if (priv->irq_enabled == 0)
@@ -3049,6 +3063,7 @@ bool NicIFDisableNIC(struct net_device *dev)
 	bool	status = true;
 	struct r8192_priv *priv = rtllib_priv(dev);
 	u8 tmp_state = 0;
+
 	RT_TRACE(COMP_PS, "=========>%s()\n", __func__);
 	priv->bdisable_nic = true;
 	tmp_state = priv->rtllib->state;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 2297fc2..9cc4af8 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -137,6 +137,7 @@ static	void	dm_ctstoself(struct net_device *dev);
 void init_hal_dm(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	priv->DM_Type = DM_Type_ByDriver;
 
 	priv->undecorated_smoothed_pwdb = -1;
@@ -167,6 +168,7 @@ void deinit_hal_dm(struct net_device *dev)
 void hal_dm_watchdog(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (priv->being_init_adapter)
 		return;
 
@@ -343,6 +345,7 @@ static void dm_check_rate_adaptive(struct net_device *dev)
 		currentRATR = read_nic_dword(dev, RATR0);
 		if (targetRATR !=  currentRATR) {
 			u32 ratr_value;
+
 			ratr_value = targetRATR;
 			RT_TRACE(COMP_RATE,
 				 "currentRATR = %x, targetRATR = %x\n",
@@ -1362,6 +1365,7 @@ static void dm_InitializeTXPowerTracking_ThermalMeter(struct net_device *dev)
 void dm_initialize_txpower_tracking(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (priv->IC_Cut >= IC_VersionCut_D)
 		dm_InitializeTXPowerTracking_TSSI(dev);
 	else
@@ -1372,6 +1376,7 @@ static void dm_CheckTXPowerTracking_TSSI(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	static u32 tx_power_track_counter;
+
 	RT_TRACE(COMP_POWER_TRACKING, "%s()\n", __func__);
 	if (read_nic_byte(dev, 0x11e) == 1)
 		return;
@@ -1437,6 +1442,7 @@ static void dm_CCKTxPowerAdjust_TSSI(struct net_device *dev, bool  bInCH14)
 {
 	u32 TempVal;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	TempVal = 0;
 	if (!bInCH14) {
 		TempVal = (u32)(priv->cck_txbbgain_table[(u8)(priv->CCKPresentAttentuation)].ccktxbb_valuearray[0] +
@@ -1530,6 +1536,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 void dm_cck_txpower_adjust(struct net_device *dev, bool  binch14)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (priv->IC_Cut >= IC_VersionCut_D)
 		dm_CCKTxPowerAdjust_TSSI(dev, binch14);
 	else
@@ -1702,6 +1709,7 @@ void dm_change_dynamic_initgain_thresh(struct net_device *dev,
 static void dm_dig_init(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	dm_digtable.dig_enable_flag	= true;
 	dm_digtable.Backoff_Enable_Flag = true;
 
@@ -2129,6 +2137,7 @@ static void dm_check_edca_turbo(struct net_device *dev)
 			"self_softap"
 		};
 		static int wb_tmp;
+
 		if (wb_tmp == 0) {
 			printk(KERN_INFO "%s():iot peer is %s, bssid:"
 			       " %pM\n", __func__,
@@ -2187,6 +2196,7 @@ static void dm_check_edca_turbo(struct net_device *dev)
 	} else {
 		 if (priv->bcurrent_turbo_EDCA) {
 			u8 tmp = AC0_BE;
+
 			priv->rtllib->SetHwRegHandler(dev, HW_VAR_AC_PARAM, (u8 *)(&tmp));
 			priv->bcurrent_turbo_EDCA = false;
 		}
@@ -2581,6 +2591,7 @@ static void dm_init_fsync(struct net_device *dev)
 static void dm_deInit_fsync(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	del_timer_sync(&priv->fsync_timer);
 }
 
@@ -2596,6 +2607,7 @@ void dm_fsync_timer_callback(unsigned long data)
 	    priv->rtllib->bfsync_enable &&
 	    (priv->rtllib->pHTInfo->IOTAction & HT_IOT_ACT_CDD_FSYNC)) {
 		u32 rate_bitmap;
+
 		for (rate_index = 0; rate_index <= 27; rate_index++) {
 			rate_bitmap  = 1 << rate_index;
 			if (priv->rtllib->fsync_rate_bitmap &  rate_bitmap)
@@ -2690,6 +2702,7 @@ static void dm_StartHWFsync(struct net_device *dev)
 {
 	u8 rf_timing = 0x77;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c12cf);
 	priv->rtllib->SetHwRegHandler(dev, HW_VAR_RF_TIMING,
@@ -2701,6 +2714,7 @@ static void dm_EndHWFsync(struct net_device *dev)
 {
 	u8 rf_timing = 0xaa;
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	RT_TRACE(COMP_HALDM, "%s\n", __func__);
 	write_nic_dword(dev, rOFDM0_RxDetector2, 0x465c52cd);
 	priv->rtllib->SetHwRegHandler(dev, HW_VAR_RF_TIMING, (u8 *)
@@ -2923,6 +2937,7 @@ static void dm_dynamic_txpower(struct net_device *dev)
 	struct r8192_priv *priv = rtllib_priv(dev);
 	unsigned int txhipower_threshhold = 0;
 	unsigned int txlowpower_threshold = 0;
+
 	if (priv->rtllib->bdynamic_txpower_enable != true) {
 		priv->bDynamicTxHighPower = false;
 		priv->bDynamicTxLowPower = false;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
index a8c2ade..4856b76 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_ps.c
@@ -33,6 +33,7 @@ static void rtl8192_hw_sleep_down(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	unsigned long flags = 0;
+
 	spin_lock_irqsave(&priv->rf_ps_lock, flags);
 	if (priv->RFChangeInProgress) {
 		spin_unlock_irqrestore(&priv->rf_ps_lock, flags);
@@ -51,6 +52,7 @@ void rtl8192_hw_sleep_wq(void *data)
 	struct rtllib_device *ieee = container_of_dwork_rsl(data,
 				     struct rtllib_device, hw_sleep_wq);
 	struct net_device *dev = ieee->dev;
+
 	rtl8192_hw_sleep_down(dev);
 }
 
@@ -58,6 +60,7 @@ void rtl8192_hw_wakeup(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
 	unsigned long flags = 0;
+
 	spin_lock_irqsave(&priv->rf_ps_lock, flags);
 	if (priv->RFChangeInProgress) {
 		spin_unlock_irqrestore(&priv->rf_ps_lock, flags);
@@ -77,8 +80,8 @@ void rtl8192_hw_wakeup_wq(void *data)
 	struct rtllib_device *ieee = container_of_dwork_rsl(data,
 				     struct rtllib_device, hw_wakeup_wq);
 	struct net_device *dev = ieee->dev;
-	rtl8192_hw_wakeup(dev);
 
+	rtl8192_hw_wakeup(dev);
 }
 
 #define MIN_SLEEP_TIME 50
@@ -179,6 +182,7 @@ void IPSLeave_wq(void *data)
 				     struct rtllib_device, ips_leave_wq);
 	struct net_device *dev = ieee->dev;
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	down(&priv->rtllib->ips_sem);
 	IPSLeave(dev);
 	up(&priv->rtllib->ips_sem);
@@ -188,6 +192,7 @@ void rtllib_ips_leave_wq(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
 	enum rt_rf_power_state rtState;
+
 	rtState = priv->rtllib->eRFPowerState;
 
 	if (priv->rtllib->PowerSaveControl.bInactivePs) {
@@ -209,6 +214,7 @@ void rtllib_ips_leave_wq(struct net_device *dev)
 void rtllib_ips_leave(struct net_device *dev)
 {
 	struct r8192_priv *priv = (struct r8192_priv *)rtllib_priv(dev);
+
 	down(&priv->rtllib->ips_sem);
 	IPSLeave(dev);
 	up(&priv->rtllib->ips_sem);
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 5287004..df0323f 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -54,6 +54,7 @@ static int r8192_wx_get_rate(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	return rtllib_wx_get_rate(priv->rtllib, info, wrqu, extra);
 }
 
@@ -103,6 +104,7 @@ static int r8192_wx_get_rts(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	return rtllib_wx_get_rts(priv->rtllib, info, wrqu, extra);
 }
 
@@ -132,6 +134,7 @@ static int r8192_wx_get_power(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	return rtllib_wx_get_power(priv->rtllib, info, wrqu, extra);
 }
 
@@ -480,6 +483,7 @@ static int r8192_wx_set_scan(struct net_device *dev, struct iw_request_info *a,
 
 	if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
 		struct iw_scan_req *req = (struct iw_scan_req *)b;
+
 		if (req->essid_len) {
 			ieee->current_network.ssid_len = req->essid_len;
 			memcpy(ieee->current_network.ssid, req->essid,
@@ -654,6 +658,7 @@ static int r8192_wx_get_name(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	return rtllib_wx_get_name(priv->rtllib, info, wrqu, extra);
 }
 
@@ -934,6 +939,7 @@ static int r8192_wx_get_sens(struct net_device *dev,
 			     union iwreq_data *wrqu, char *extra)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
+
 	if (priv->rf_set_sens == NULL)
 		return -1; /* we have not this support for this radio */
 	wrqu->sens.value = priv->sens;
@@ -995,6 +1001,7 @@ static int r8192_wx_set_enc_ext(struct net_device *dev,
 		struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 		struct iw_point *encoding = &wrqu->encoding;
 		u8 idx = 0, alg = 0, group = 0;
+
 		if ((encoding->flags & IW_ENCODE_DISABLED) ||
 		     ext->alg == IW_ENCODE_ALG_NONE) {
 			ieee->pairwise_key_type = ieee->group_key_type
@@ -1309,6 +1316,7 @@ static struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	int tmp_level = 0;
 	int tmp_qual = 0;
 	int tmp_noise = 0;
+
 	if (ieee->state < RTLLIB_LINKED) {
 		wstats->qual.qual = 10;
 		wstats->qual.level = 0;
diff --git a/drivers/staging/rtl8192e/rtl819x_BAProc.c b/drivers/staging/rtl8192e/rtl819x_BAProc.c
index 48a142b..b1fb5705 100644
--- a/drivers/staging/rtl8192e/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_BAProc.c
@@ -196,6 +196,7 @@ static void rtllib_send_ADDBAReq(struct rtllib_device *ieee, u8 *dst,
 				 struct ba_record *pBA)
 {
 	struct sk_buff *skb = NULL;
+
 	skb = rtllib_ADDBA(ieee, dst, pBA, 0, ACT_ADDBAREQ);
 
 	if (skb) {
@@ -212,6 +213,7 @@ static void rtllib_send_ADDBARsp(struct rtllib_device *ieee, u8 *dst,
 				 struct ba_record *pBA, u16 StatusCode)
 {
 	struct sk_buff *skb = NULL;
+
 	skb = rtllib_ADDBA(ieee, dst, pBA, StatusCode, ACT_ADDBARSP);
 	if (skb)
 		softmac_mgmt_xmit(skb, ieee);
@@ -226,6 +228,7 @@ static void rtllib_send_DELBA(struct rtllib_device *ieee, u8 *dst,
 			      u16 ReasonCode)
 {
 	struct sk_buff *skb = NULL;
+
 	skb = rtllib_DELBA(ieee, dst, pBA, TxRxSelect, ReasonCode);
 	if (skb)
 		softmac_mgmt_xmit(skb, ieee);
@@ -312,6 +315,7 @@ int rtllib_rx_ADDBAReq(struct rtllib_device *ieee, struct sk_buff *skb)
 OnADDBAReq_Fail:
 	{
 		struct ba_record BA;
+
 		BA.BaParamSet = *pBaParamSet;
 		BA.BaTimeoutValue = *pBaTimeoutVal;
 		BA.DialogToken = *pDialogToken;
@@ -416,6 +420,7 @@ int rtllib_rx_ADDBARsp(struct rtllib_device *ieee, struct sk_buff *skb)
 OnADDBARsp_Reject:
 	{
 		struct ba_record BA;
+
 		BA.BaParamSet = *pBaParamSet;
 		rtllib_send_DELBA(ieee, dst, &BA, TX_DIR, ReasonCode);
 		return 0;
diff --git a/drivers/staging/rtl8192e/rtl819x_HTProc.c b/drivers/staging/rtl8192e/rtl819x_HTProc.c
index 8b74129..a6d861a 100644
--- a/drivers/staging/rtl8192e/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_HTProc.c
@@ -340,6 +340,7 @@ static void HTIOTPeerDetermine(struct rtllib_device *ieee)
 {
 	struct rt_hi_throughput *pHTInfo = ieee->pHTInfo;
 	struct rtllib_network *net = &ieee->current_network;
+
 	if (net->bssht.bdRT2RTAggregation) {
 		pHTInfo->IOTPeer = HT_IOT_PEER_REALTEK;
 		if (net->bssht.RT2RT_HT_Mode & RT_HT_CAP_USE_92SE)
@@ -425,6 +426,7 @@ static u8 HTIOTActIsCCDFsync(struct rtllib_device *ieee)
 static void HTIOTActDetermineRaFunc(struct rtllib_device *ieee, bool bPeerRx2ss)
 {
 	struct rt_hi_throughput *pHTInfo = ieee->pHTInfo;
+
 	pHTInfo->IOTRaFunc &= HT_IOT_RAFUNC_DISABLE_ALL;
 
 	if (pHTInfo->IOTPeer == HT_IOT_PEER_RALINK && !bPeerRx2ss)
@@ -457,6 +459,7 @@ void HTConstructCapabilityElement(struct rtllib_device *ieee, u8 *posHTCap,
 
 	if ((bAssoc) && (pHT->ePeerHTSpecVer == HT_SPEC_VER_EWC)) {
 		u8	EWC11NHTCap[] = {0x00, 0x90, 0x4c, 0x33};
+
 		memcpy(posHTCap, EWC11NHTCap, sizeof(EWC11NHTCap));
 		pCapELE = (struct ht_capab_ele *)&(posHTCap[4]);
 		*len = 30 + 2;
@@ -529,6 +532,7 @@ void HTConstructInfoElement(struct rtllib_device *ieee, u8 *posHTInfo,
 {
 	struct rt_hi_throughput *pHT = ieee->pHTInfo;
 	struct ht_info_ele *pHTInfoEle = (struct ht_info_ele *)posHTInfo;
+
 	if ((posHTInfo == NULL) || (pHTInfoEle == NULL)) {
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "posHTInfo or pHTInfoEle can't be "
 			     "null in HTConstructInfoElement()\n");
@@ -595,6 +599,7 @@ void HTConstructRT2RTAggElement(struct rtllib_device *ieee, u8 *posRT2RTAgg,
 static u8 HT_PickMCSRate(struct rtllib_device *ieee, u8 *pOperateMCS)
 {
 	u8 i;
+
 	if (pOperateMCS == NULL) {
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "pOperateMCS can't be null"
 			     " in HT_PickMCSRate()\n");
@@ -629,6 +634,7 @@ u8 HTGetHighestMCSRate(struct rtllib_device *ieee, u8 *pMCSRateSet,
 	u8		bitMap;
 	u8		mcsRate = 0;
 	u8		availableMcsRate[16];
+
 	if (pMCSRateSet == NULL || pMCSFilter == NULL) {
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "pMCSRateSet or pMCSFilter can't "
 			     "be null in HTGetHighestMCSRate()\n");
@@ -846,6 +852,7 @@ void HTInitializeHTInfo(struct rtllib_device *ieee)
 
 	{
 		u8 *RegHTSuppRateSets = &(ieee->RegHTSuppRateSet[0]);
+
 		RegHTSuppRateSets[0] = 0xFF;
 		RegHTSuppRateSets[1] = 0xFF;
 		RegHTSuppRateSets[4] = 0x01;
diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
index 52b2977..6c0158e 100644
--- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
@@ -143,6 +143,7 @@ void TSInitialize(struct rtllib_device *ieee)
 	struct rx_ts_record *pRxTS  = ieee->RxTsRecord;
 	struct rx_reorder_entry *pRxReorderEntry = ieee->RxReorderEntry;
 	u8				count = 0;
+
 	RTLLIB_DEBUG(RTLLIB_DL_TS, "==========>%s()\n", __func__);
 	INIT_LIST_HEAD(&ieee->Tx_TS_Admit_List);
 	INIT_LIST_HEAD(&ieee->Tx_TS_Pending_List);
@@ -233,6 +234,7 @@ static struct ts_common_info *SearchAdmitTRStream(struct rtllib_device *ieee,
 	bool	search_dir[4] = {0};
 	struct list_head *psearch_list;
 	struct ts_common_info *pRet = NULL;
+
 	if (ieee->iw_mode == IW_MODE_MASTER) {
 		if (TxRxSelect == TX_DIR) {
 			search_dir[DIR_DOWN] = true;
@@ -310,6 +312,7 @@ bool GetTs(struct rtllib_device *ieee, struct ts_common_info **ppTS,
 	   u8 *Addr, u8 TID, enum tr_select TxRxSelect, bool bAddNewTs)
 {
 	u8	UP = 0;
+
 	if (is_multicast_ether_addr(Addr)) {
 		RTLLIB_DEBUG(RTLLIB_DL_ERR, "ERR! get TS for Broadcast or "
 			     "Multicast\n");
@@ -443,6 +446,7 @@ static void RemoveTsEntry(struct rtllib_device *ieee, struct ts_common_info *pTs
 			{
 				int i = 0;
 				struct rtllib_rxb *prxb = pRxReorderEntry->prxb;
+
 				if (unlikely(!prxb))
 					return;
 				for (i = 0; i < prxb->nr_subframes; i++)
@@ -455,6 +459,7 @@ static void RemoveTsEntry(struct rtllib_device *ieee, struct ts_common_info *pTs
 		}
 	} else {
 		struct tx_ts_record *pTxTS = (struct tx_ts_record *)pTs;
+
 		del_timer_sync(&pTxTS->TsAddBaTimer);
 	}
 }
@@ -462,6 +467,7 @@ static void RemoveTsEntry(struct rtllib_device *ieee, struct ts_common_info *pTs
 void RemovePeerTS(struct rtllib_device *ieee, u8 *Addr)
 {
 	struct ts_common_info *pTS, *pTmpTS;
+
 	printk(KERN_INFO "===========>RemovePeerTS, %pM\n", Addr);
 
 	list_for_each_entry_safe(pTS, pTmpTS, &ieee->Tx_TS_Pending_List, List) {
diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 83f5f57..e91f130 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1473,6 +1473,7 @@ static inline u8 Frame_QoSTID(u8 *buf)
 {
 	struct rtllib_hdr_3addr *hdr;
 	u16 fc;
+
 	hdr = (struct rtllib_hdr_3addr *)buf;
 	fc = le16_to_cpu(hdr->frame_ctl);
 	return (u8)((union frameqos *)(buf + (((fc & RTLLIB_FCTL_TODS) &&
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
index 5e5c76b..3465e00 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
@@ -90,6 +90,7 @@ fail:
 static void rtllib_ccmp_deinit(void *priv)
 {
 	struct rtllib_ccmp_data *_priv = priv;
+
 	if (_priv && _priv->tfm)
 		crypto_free_cipher((void *)_priv->tfm);
 	kfree(priv);
@@ -99,6 +100,7 @@ static void rtllib_ccmp_deinit(void *priv)
 static inline void xor_block(u8 *b, u8 *a, size_t len)
 {
 	int i;
+
 	for (i = 0; i < len; i++)
 		b[i] ^= a[i];
 }
@@ -415,6 +417,7 @@ static int rtllib_ccmp_get_key(void *key, int len, u8 *seq, void *priv)
 static void rtllib_ccmp_print_stats(struct seq_file *m, void *priv)
 {
 	struct rtllib_ccmp_data *ccmp = priv;
+
 	seq_printf(m,
 		   "key[%d] alg=CCMP key_set=%d "
 		   "tx_pn=%pM rx_pn=%pM "
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 7b5366b..78db2b6 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -285,6 +285,7 @@ static void tkip_mixing_phase2(u8 *WEPSeed, const u8 *TK, const u16 *TTAK,
 #ifdef __BIG_ENDIAN
 	{
 		int i;
+
 		for (i = 0; i < 6; i++)
 			PPK[i] = (PPK[i] << 8) | (PPK[i] >> 8);
 	}
@@ -389,6 +390,7 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u32 crc;
 	struct scatterlist sg;
 	int plen;
+
 	if (skb->len < hdr_len + 8 + 4)
 		return -1;
 
@@ -617,6 +619,7 @@ static int rtllib_michael_mic_verify(struct sk_buff *skb, int keyidx,
 
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
 		struct rtllib_hdr_4addr *hdr;
+
 		hdr = (struct rtllib_hdr_4addr *) skb->data;
 		printk(KERN_DEBUG "%s: Michael MIC verification failed for "
 		       "MSDU from %pM keyidx=%d\n",
@@ -693,6 +696,7 @@ static int rtllib_tkip_get_key(void *key, int len, u8 *seq, void *priv)
 		/* Return the sequence number of the last transmitted frame. */
 		u16 iv16 = tkey->tx_iv16;
 		u32 iv32 = tkey->tx_iv32;
+
 		if (iv16 == 0)
 			iv32--;
 		iv16--;
@@ -711,6 +715,7 @@ static int rtllib_tkip_get_key(void *key, int len, u8 *seq, void *priv)
 static void rtllib_tkip_print_stats(struct seq_file *m, void *priv)
 {
 	struct rtllib_tkip_data *tkip = priv;
+
 	seq_printf(m,
 		   "key[%d] alg=TKIP key_set=%d "
 		   "tx_pn=%02x%02x%02x%02x%02x%02x "
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_wep.c b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
index b0e5f1f..85145ce 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_wep.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
@@ -105,6 +105,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u32 crc;
 	u8 *icv;
 	struct scatterlist sg;
+
 	if (skb_headroom(skb) < 4 || skb_tailroom(skb) < 4 ||
 	    skb->len < hdr_len){
 		printk(KERN_ERR "Error!!! headroom=%d tailroom=%d skblen=%d"
@@ -126,6 +127,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	 * can be used to speedup attacks, so avoid using them. */
 	if ((wep->iv & 0xff00) == 0xff00) {
 		u8 B = (wep->iv >> 16) & 0xff;
+
 		if (B >= 3 && B < klen)
 			wep->iv += 0x0100;
 	}
@@ -177,6 +179,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u32 crc;
 	u8 icv[4];
 	struct scatterlist sg;
+
 	if (skb->len < hdr_len + 8)
 		return -1;
 
@@ -250,6 +253,7 @@ static int prism2_wep_get_key(void *key, int len, u8 *seq, void *priv)
 static void prism2_wep_print_stats(struct seq_file *m, void *priv)
 {
 	struct prism2_wep_data *wep = priv;
+
 	seq_printf(m, "key[%d] alg=WEP len=%d\n", wep->key_idx, wep->key_len);
 }
 
diff --git a/drivers/staging/rtl8192e/rtllib_module.c b/drivers/staging/rtl8192e/rtllib_module.c
index ba95149..91e98e8 100644
--- a/drivers/staging/rtl8192e/rtllib_module.c
+++ b/drivers/staging/rtl8192e/rtllib_module.c
@@ -217,6 +217,7 @@ static ssize_t write_debug_level(struct file *file, const char __user *buffer,
 {
 	unsigned long val;
 	int err = kstrtoul_from_user(buffer, count, 0, &val);
+
 	if (err)
 		return err;
 	rtllib_debug_level = val;
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 7db3e74..9ded541 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -290,6 +290,7 @@ rtllib_rx_frame_decrypt(struct rtllib_device *ieee, struct sk_buff *skb,
 
 	if (ieee->hwsec_active) {
 		struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
+
 		tcb_desc->bHwSec = 1;
 
 		if (ieee->need_sw_enc)
@@ -330,6 +331,7 @@ rtllib_rx_frame_decrypt_msdu(struct rtllib_device *ieee, struct sk_buff *skb,
 		return 0;
 	if (ieee->hwsec_active) {
 		struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
+
 		tcb_desc->bHwSec = 1;
 
 		if (ieee->need_sw_enc)
@@ -389,6 +391,7 @@ static int is_duplicate_packet(struct rtllib_device *ieee,
 		struct ieee_ibss_seq *entry = NULL;
 		u8 *mac = header->addr2;
 		int index = mac[5] % IEEE_IBSS_MAC_HASH_SIZE;
+
 		list_for_each(p, &ieee->ibss_mac_hash[index]) {
 			entry = list_entry(p, struct ieee_ibss_seq, list);
 			if (!memcmp(entry->mac, mac, ETH_ALEN))
@@ -471,8 +474,10 @@ void rtllib_indicate_packets(struct rtllib_device *ieee, struct rtllib_rxb **prx
 	struct net_device_stats *stats = &ieee->stats;
 	u8 i = 0 , j = 0;
 	u16 ethertype;
+
 	for (j = 0; j < index; j++) {
 		struct rtllib_rxb *prxb = prxbIndicateArray[j];
+
 		for (i = 0; i < prxb->nr_subframes; i++) {
 			struct sk_buff *sub_skb = prxb->subframes[i];
 
@@ -572,6 +577,7 @@ static void RxReorderIndicatePacket(struct rtllib_device *ieee,
 		pHTInfo->RxReorderDropCounter++;
 		{
 			int i;
+
 			for (i = 0; i < prxb->nr_subframes; i++)
 				dev_kfree_skb(prxb->subframes[i]);
 			kfree(prxb);
@@ -638,6 +644,7 @@ static void RxReorderIndicatePacket(struct rtllib_device *ieee,
 				list_add_tail(&pReorderEntry->List,
 					      &ieee->RxReorder_Unused_List); {
 					int i;
+
 					for (i = 0; i < prxb->nr_subframes; i++)
 						dev_kfree_skb(prxb->subframes[i]);
 					kfree(prxb);
@@ -661,6 +668,7 @@ static void RxReorderIndicatePacket(struct rtllib_device *ieee,
 				     "dropped!!\n");
 			{
 				int i;
+
 				for (i = 0; i < prxb->nr_subframes; i++)
 					dev_kfree_skb(prxb->subframes[i]);
 				kfree(prxb);
@@ -905,6 +913,7 @@ static int rtllib_rx_check_duplicate(struct rtllib_device *ieee,
 		}
 	} else {
 		struct rx_ts_record *pRxTS = NULL;
+
 		if (GetTs(ieee, (struct ts_common_info **) &pRxTS, hdr->addr2,
 			(u8)Frame_QoSTID((u8 *)(skb->data)), RX_DIR, true)) {
 			if ((fc & (1<<11)) && (frag == pRxTS->RxLastFragNum) &&
@@ -1074,6 +1083,7 @@ static int rtllib_rx_decrypt(struct rtllib_device *ieee, struct sk_buff *skb,
 	if ((frag != 0 || (fc & RTLLIB_FCTL_MOREFRAGS))) {
 		int flen;
 		struct sk_buff *frag_skb = rtllib_frag_cache_get(ieee, hdr);
+
 		RTLLIB_DEBUG_FRAG("Rx Fragment received (%u)\n", frag);
 
 		if (!frag_skb) {
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 684ceed..cbe1d35 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -130,6 +130,7 @@ void rtllib_TURBO_Info(struct rtllib_device *ieee, u8 **tag_p)
 static void enqueue_mgmt(struct rtllib_device *ieee, struct sk_buff *skb)
 {
 	int nh;
+
 	nh = (ieee->mgmt_queue_head + 1) % MGMT_QUEUE_NUM;
 
 /*
@@ -222,6 +223,7 @@ inline void softmac_mgmt_xmit(struct sk_buff *skb, struct rtllib_device *ieee)
 		(struct rtllib_hdr_3addr  *) skb->data;
 
 	struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + 8);
+
 	spin_lock_irqsave(&ieee->lock, flags);
 
 	/* called with 2nd param 0, no mgmt lock required */
@@ -387,6 +389,7 @@ struct sk_buff *rtllib_get_beacon_(struct rtllib_device *ieee);
 static void rtllib_send_beacon(struct rtllib_device *ieee)
 {
 	struct sk_buff *skb;
+
 	if (!ieee->ieee_up)
 		return;
 	skb = rtllib_get_beacon_(ieee);
@@ -495,6 +498,7 @@ EXPORT_SYMBOL(rtllib_DisableIntelPromiscuousMode);
 static void rtllib_send_probe(struct rtllib_device *ieee, u8 is_mesh)
 {
 	struct sk_buff *skb;
+
 	skb = rtllib_probe_req(ieee);
 	if (skb) {
 		softmac_mgmt_xmit(skb, ieee);
@@ -657,6 +661,7 @@ out1:
 static void rtllib_beacons_start(struct rtllib_device *ieee)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 1;
@@ -795,6 +800,7 @@ inline struct sk_buff *rtllib_authentication_req(struct rtllib_network *beacon,
 	struct sk_buff *skb;
 	struct rtllib_authentication *auth;
 	int  len = 0;
+
 	len = sizeof(struct rtllib_authentication) + challengelen +
 		     ieee->tx_headroom + 4;
 	skb = dev_alloc_skb(len);
@@ -1043,6 +1049,7 @@ static struct sk_buff *rtllib_auth_resp(struct rtllib_device *ieee, int status,
 	struct sk_buff *skb = NULL;
 	struct rtllib_authentication *auth;
 	int len = ieee->tx_headroom + sizeof(struct rtllib_authentication) + 1;
+
 	skb = dev_alloc_skb(len);
 	if (!skb)
 		return NULL;
@@ -1139,8 +1146,8 @@ static void rtllib_resp_to_auth(struct rtllib_device *ieee, int s, u8 *dest)
 
 static void rtllib_resp_to_probe(struct rtllib_device *ieee, u8 *dest)
 {
-
 	struct sk_buff *buf = rtllib_probe_resp(ieee, dest);
+
 	if (buf)
 		softmac_mgmt_xmit(buf, ieee);
 }
@@ -1192,6 +1199,7 @@ inline struct sk_buff *rtllib_association_req(struct rtllib_network *beacon,
 	unsigned int turbo_info_len = beacon->Turbo_Enable ? 9 : 0;
 
 	int len = 0;
+
 	crypt = ieee->crypt_info.crypt[ieee->crypt_info.tx_keyidx];
 	if (crypt != NULL)
 		encrypt = ieee->host_encrypt && crypt && crypt->ops &&
@@ -1339,6 +1347,7 @@ inline struct sk_buff *rtllib_association_req(struct rtllib_network *beacon,
 	if (beacon->BssCcxVerNumber >= 2) {
 		u8 CcxVerNumBuf[] = {0x00, 0x40, 0x96, 0x03, 0x00};
 		struct octet_string osCcxVerNum;
+
 		CcxVerNumBuf[4] = beacon->BssCcxVerNumber;
 		osCcxVerNum.Octet = CcxVerNumBuf;
 		osCcxVerNum.Length = sizeof(CcxVerNumBuf);
@@ -1418,8 +1427,8 @@ inline struct sk_buff *rtllib_association_req(struct rtllib_network *beacon,
 
 void rtllib_associate_abort(struct rtllib_device *ieee)
 {
-
 	unsigned long flags;
+
 	spin_lock_irqsave(&ieee->lock, flags);
 
 	ieee->associate_seq++;
@@ -1789,6 +1798,7 @@ static inline u16 auth_parse(struct sk_buff *skb, u8 **challenge, int *chlen)
 {
 	struct rtllib_authentication *a;
 	u8 *t;
+
 	if (skb->len <  (sizeof(struct rtllib_authentication) -
 	    sizeof(struct rtllib_info_element))) {
 		RTLLIB_DEBUG_MGMT("invalid len in auth resp: %d\n", skb->len);
@@ -1924,6 +1934,7 @@ static inline u16 assoc_parse(struct rtllib_device *ieee, struct sk_buff *skb,
 void rtllib_rx_probe_rq(struct rtllib_device *ieee, struct sk_buff *skb)
 {
 	u8 dest[ETH_ALEN];
+
 	ieee->softmac_stats.rx_probe_rq++;
 	if (probe_rq_parse(ieee, skb, dest) > 0) {
 		ieee->softmac_stats.tx_probe_rs++;
@@ -1936,6 +1947,7 @@ static inline void rtllib_rx_auth_rq(struct rtllib_device *ieee,
 {
 	u8 dest[ETH_ALEN];
 	int status;
+
 	ieee->softmac_stats.rx_auth_rq++;
 
 	status = auth_rq_parse(skb, dest);
@@ -2026,6 +2038,7 @@ static short rtllib_sta_ps_sleep(struct rtllib_device *ieee, u64 *time)
 			u8 LPSAwakeIntvl_tmp = 0;
 			u8 period = ieee->current_network.dtim_period;
 			u8 count = ieee->current_network.tim.tim_count;
+
 			if (count == 0) {
 				if (pPSC->LPSAwakeIntvl > period)
 					LPSAwakeIntvl_tmp = period +
@@ -2514,6 +2527,7 @@ void rtllib_softmac_xmit(struct rtllib_txb *txb, struct rtllib_device *ieee)
 static void rtllib_resume_tx(struct rtllib_device *ieee)
 {
 	int i;
+
 	for (i = ieee->tx_pending.frag; i < ieee->tx_pending.txb->nr_frags;
 	     i++) {
 
@@ -2606,6 +2620,7 @@ void rtllib_stop_queue(struct rtllib_device *ieee)
 void rtllib_stop_all_queues(struct rtllib_device *ieee)
 {
 	unsigned int i;
+
 	for (i = 0; i < ieee->dev->num_tx_queues; i++)
 		netdev_get_tx_queue(ieee->dev, i)->trans_start = jiffies;
 
@@ -2801,6 +2816,7 @@ inline void rtllib_start_ibss(struct rtllib_device *ieee)
 void rtllib_start_bss(struct rtllib_device *ieee)
 {
 	unsigned long flags;
+
 	if (IS_DOT11D_ENABLE(ieee) && !IS_COUNTRY_IE_VALID(ieee)) {
 		if (!ieee->bGlobalDomain)
 			return;
@@ -2900,6 +2916,7 @@ struct sk_buff *rtllib_get_beacon_(struct rtllib_device *ieee)
 
 	struct sk_buff *skb;
 	struct rtllib_probe_response *b;
+
 	skb = rtllib_probe_resp(ieee, broadcast_addr);
 
 	if (!skb)
@@ -3049,6 +3066,7 @@ void rtllib_start_protocol(struct rtllib_device *ieee)
 void rtllib_softmac_init(struct rtllib_device *ieee)
 {
 	int i;
+
 	memset(&ieee->current_network, 0, sizeof(struct rtllib_network));
 
 	ieee->state = RTLLIB_NOLINK;
@@ -3513,6 +3531,7 @@ inline struct sk_buff *rtllib_disassociate_skb(struct rtllib_network *beacon,
 	struct sk_buff *skb;
 	struct rtllib_disassoc *disass;
 	int len = sizeof(struct rtllib_disassoc) + ieee->tx_headroom;
+
 	skb = dev_alloc_skb(len);
 
 	if (!skb)
diff --git a/drivers/staging/rtl8192e/rtllib_softmac_wx.c b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
index 65b650c..d077f49 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac_wx.c
@@ -244,6 +244,7 @@ int rtllib_wx_get_rate(struct rtllib_device *ieee,
 			     union iwreq_data *wrqu, char *extra)
 {
 	u32 tmp_rate = 0;
+
 	tmp_rate = TxCountToDataRate(ieee,
 				     ieee->softmac_stats.CurrentShowTxate);
 	wrqu->bitrate.value = tmp_rate * 500000;
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index b7dd153..41bb8c2 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -224,6 +224,7 @@ static struct rtllib_txb *rtllib_alloc_txb(int nr_frags, int txb_size,
 {
 	struct rtllib_txb *txb;
 	int i;
+
 	txb = kmalloc(sizeof(struct rtllib_txb) + (sizeof(u8 *) * nr_frags),
 		      gfp_mask);
 	if (!txb)
@@ -438,6 +439,7 @@ static void rtllib_query_protectionmode(struct rtllib_device *ieee,
 		return;
 	} else {
 		struct rt_hi_throughput *pHTInfo = ieee->pHTInfo;
+
 		while (true) {
 			if (pHTInfo->IOTAction & HT_IOT_ACT_FORCED_CTS2SELF) {
 				tcb_desc->bCTSEnable	= true;
@@ -458,6 +460,7 @@ static void rtllib_query_protectionmode(struct rtllib_device *ieee,
 			}
 			if (pHTInfo->bCurrentHTSupport  && pHTInfo->bEnableHT) {
 				u8 HTOpMode = pHTInfo->CurrentOpMode;
+
 				if ((pHTInfo->bCurBW40MHz && (HTOpMode == 2 ||
 				     HTOpMode == 3)) ||
 				     (!pHTInfo->bCurBW40MHz && HTOpMode == 3)) {
@@ -518,6 +521,7 @@ u16 rtllib_query_seqnum(struct rtllib_device *ieee, struct sk_buff *skb,
 		return 0;
 	if (IsQoSDataFrame(skb->data)) {
 		struct tx_ts_record *pTS = NULL;
+
 		if (!GetTs(ieee, (struct ts_common_info **)(&pTS), dst,
 		    skb->priority, TX_DIR, true))
 			return 0;
diff --git a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
index 13af43b..9e0f975 100644
--- a/drivers/staging/rtl8192e/rtllib_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_wx.c
@@ -158,6 +158,7 @@ static inline char *rtl819x_translate_scan(struct rtllib_device *ieee,
 		struct ht_capab_ele *ht_cap = NULL;
 		bool is40M = false, isShortGI = false;
 		u8 max_mcs = 0;
+
 		if (!memcmp(network->bssht.bdHTCapBuf, EWC11NHTCap, 4))
 			ht_cap = (struct ht_capab_ele *)
 				 &network->bssht.bdHTCapBuf[4];
@@ -212,6 +213,7 @@ static inline char *rtl819x_translate_scan(struct rtllib_device *ieee,
 	memset(&iwe, 0, sizeof(iwe));
 	if (network->wpa_ie_len) {
 		char buf[MAX_WPA_IE_LEN];
+
 		memcpy(buf, network->wpa_ie, network->wpa_ie_len);
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = network->wpa_ie_len;
@@ -220,6 +222,7 @@ static inline char *rtl819x_translate_scan(struct rtllib_device *ieee,
 	memset(&iwe, 0, sizeof(iwe));
 	if (network->rsn_ie_len) {
 		char buf[MAX_WPA_IE_LEN];
+
 		memcpy(buf, network->rsn_ie, network->rsn_ie_len);
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = network->rsn_ie_len;
@@ -230,6 +233,7 @@ static inline char *rtl819x_translate_scan(struct rtllib_device *ieee,
 	memset(&iwe, 0, sizeof(iwe));
 	if (network->wzc_ie_len) {
 		char buf[MAX_WZC_IE_LEN];
+
 		memcpy(buf, network->wzc_ie, network->wzc_ie_len);
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = network->wzc_ie_len;
@@ -262,6 +266,7 @@ int rtllib_wx_get_scan(struct rtllib_device *ieee,
 	char *stop = ev + wrqu->data.length;
 	int i = 0;
 	int err = 0;
+
 	RTLLIB_DEBUG_WX("Getting scan\n");
 	down(&ieee->wx_sem);
 	spin_lock_irqsave(&ieee->lock, flags);
-- 
1.9.1

