Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaFROSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:18:31 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:42746 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbaFRORo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:17:44 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2014 10:17:43 EDT
From: Christian Bay <christian.bay@studium.fau.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        lisa@xenapiadmin.com, linux-kernel@i4.cs.fau.de,
        Christian Bay <christian.bay@studium.fau.de>,
        Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Subject: [PATCH 1/2] Staging: bcm: Prototypes.h: fix checkpatch errors
Date: Wed, 18 Jun 2014 16:10:05 +0200
Message-Id: <1403100606-14881-2-git-send-email-christian.bay@studium.fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
References: <1403100606-14881-1-git-send-email-christian.bay@studium.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all errors, excluding > 80 character warnings, shown by the checkpatch
script. In detail whitespace changes according to the coding guideline are meant.
Additionally there is exactly one newline after every declaration of methods now.

Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
---
 drivers/staging/bcm/Prototypes.h | 89 +++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/bcm/Prototypes.h b/drivers/staging/bcm/Prototypes.h
index fb53a00..1ddc8b25 100644
--- a/drivers/staging/bcm/Prototypes.h
+++ b/drivers/staging/bcm/Prototypes.h
@@ -3,13 +3,13 @@
 
 VOID LinkControlResponseMessage(struct bcm_mini_adapter *Adapter, PUCHAR pucBuffer);
 
-VOID StatisticsResponse(struct bcm_mini_adapter *Adapter,PVOID pvBuffer);
+VOID StatisticsResponse(struct bcm_mini_adapter *Adapter, PVOID pvBuffer);
 
-VOID IdleModeResponse(struct bcm_mini_adapter *Adapter,PUINT puiBuffer);
+VOID IdleModeResponse(struct bcm_mini_adapter *Adapter, PUINT puiBuffer);
 
-int control_packet_handler	(struct bcm_mini_adapter *Adapter);
+int control_packet_handler(struct bcm_mini_adapter *Adapter);
 
-VOID DeleteAllClassifiersForSF(struct bcm_mini_adapter *Adapter,UINT uiSearchRuleIndex);
+VOID DeleteAllClassifiersForSF(struct bcm_mini_adapter *Adapter, UINT uiSearchRuleIndex);
 
 VOID flush_all_queues(struct bcm_mini_adapter *Adapter);
 
@@ -29,18 +29,19 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter);
 
 VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter);
 
-INT SearchSfid(struct bcm_mini_adapter *Adapter,UINT uiSfid);
+INT SearchSfid(struct bcm_mini_adapter *Adapter, UINT uiSfid);
 
-USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb);
+USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff *skb);
 
-bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
-bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
-bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtocol);
+bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPort);
 
+bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPort);
+
+bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucProtocol);
 
 INT SetupNextSend(struct bcm_mini_adapter *Adapter, /**<Logical Adapter*/
 					struct sk_buff *Packet, /**<data buffer*/
-					USHORT Vcid)	;
+					USHORT Vcid);
 
 VOID LinkMessage(struct bcm_mini_adapter *Adapter);
 
@@ -50,8 +51,8 @@ INT SendControlPacket(struct bcm_mini_adapter *Adapter, /**<Logical Adapter*/
 							char *pControlPacket/**<Control Packet*/
 							);
 
-
 int register_networkdev(struct bcm_mini_adapter *Adapter);
+
 void unregister_networkdev(struct bcm_mini_adapter *Adapter);
 
 INT AllocAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
@@ -62,13 +63,12 @@ INT FreeAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
 
 int tx_pkt_handler(struct bcm_mini_adapter *Adapter);
 
-int  reset_card_proc(struct bcm_mini_adapter *Adapter );
+int reset_card_proc(struct bcm_mini_adapter *Adapter);
 
-int run_card_proc(struct bcm_mini_adapter *Adapter );
+int run_card_proc(struct bcm_mini_adapter *Adapter);
 
 int InitCardAndDownloadFirmware(struct bcm_mini_adapter *ps_adapter);
 
-
 INT ReadMacAddressFromNVM(struct bcm_mini_adapter *Adapter);
 
 int register_control_device_interface(struct bcm_mini_adapter *ps_adapter);
@@ -79,17 +79,18 @@ int rdm(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t
 
 int wrm(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t size);
 
-int wrmalt (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int wrmalt(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int rdmalt (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int rdmalt(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int get_dsx_sf_data_to_application(struct bcm_mini_adapter *Adapter, UINT uiSFId, void __user * user_buffer);
+int get_dsx_sf_data_to_application(struct bcm_mini_adapter *Adapter, UINT uiSFId, void __user *user_buffer);
 
 void SendIdleModeResponse(struct bcm_mini_adapter *Adapter);
 
+int ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *buf);
 
-int  ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *buf);
 void GetDroppedAppCntrlPktMibs(struct bcm_host_stats_mibs *ioBuffer, struct bcm_tarang_data *pTarang);
+
 void beceem_parse_target_struct(struct bcm_mini_adapter *Adapter);
 
 int bcm_ioctl_fw_download(struct bcm_mini_adapter *Adapter, struct bcm_firmware_info *psFwInfo);
@@ -101,38 +102,32 @@ VOID ResetCounters(struct bcm_mini_adapter *Adapter);
 
 int InitLedSettings(struct bcm_mini_adapter *Adapter);
 
-struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter,USHORT usIpIdentification,ULONG SrcIP);
+struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIP);
 
 void AddFragIPClsEntry(struct bcm_mini_adapter *Adapter, struct bcm_fragmented_packet_info *psFragPktInfo);
 
-void DelFragIPClsEntry(struct bcm_mini_adapter *Adapter,USHORT usIpIdentification,ULONG SrcIp);
-
-void update_per_cid_rx (struct bcm_mini_adapter *Adapter);
+void DelFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIp);
 
-void update_per_sf_desc_cnts( struct bcm_mini_adapter *Adapter);
+void update_per_cid_rx(struct bcm_mini_adapter *Adapter);
 
-void ClearTargetDSXBuffer(struct bcm_mini_adapter *Adapter,B_UINT16 TID,bool bFreeAll);
+void update_per_sf_desc_cnts(struct bcm_mini_adapter *Adapter);
 
+void ClearTargetDSXBuffer(struct bcm_mini_adapter *Adapter, B_UINT16 TID, bool bFreeAll);
 
 void flush_queue(struct bcm_mini_adapter *Adapter, UINT iQIndex);
 
-
 INT flushAllAppQ(VOID);
 
-
 INT BeceemEEPROMBulkRead(
 	struct bcm_mini_adapter *Adapter,
 	PUINT pBuffer,
 	UINT uiOffset,
 	UINT uiNumBytes);
 
-
-
-INT WriteBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT uiEEPROMOffset, UINT uiData);
+INT WriteBeceemEEPROM(struct bcm_mini_adapter *Adapter, UINT uiEEPROMOffset, UINT uiData);
 
 INT PropagateCalParamsFromFlashToMemory(struct bcm_mini_adapter *Adapter);
 
-
 INT BeceemEEPROMBulkWrite(
 	struct bcm_mini_adapter *Adapter,
 	PUCHAR pBuffer,
@@ -140,9 +135,7 @@ INT BeceemEEPROMBulkWrite(
 	UINT uiNumBytes,
 	bool bVerify);
 
-
-INT ReadBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT dwAddress, UINT *pdwData);
-
+INT ReadBeceemEEPROM(struct bcm_mini_adapter *Adapter, UINT dwAddress, UINT *pdwData);
 
 INT BeceemNVMRead(
 	struct bcm_mini_adapter *Adapter,
@@ -157,10 +150,10 @@ INT BeceemNVMWrite(
 	UINT uiNumBytes,
 	bool bVerify);
 
-
 INT BcmInitNVM(struct bcm_mini_adapter *Adapter);
 
-INT BcmUpdateSectorSize(struct bcm_mini_adapter *Adapter,UINT uiSectorSize);
+INT BcmUpdateSectorSize(struct bcm_mini_adapter *Adapter, UINT uiSectorSize);
+
 bool IsSectionExistInFlash(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val section);
 
 INT BcmGetFlash2xSectionalBitMap(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_bitmap *psFlash2xBitMap);
@@ -183,40 +176,42 @@ INT BcmFlash2xBulkRead(
 INT BcmGetSectionValStartOffset(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val eFlashSectionVal);
 
 INT BcmSetActiveSection(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val eFlash2xSectVal);
+
 INT BcmAllocFlashCSStructure(struct bcm_mini_adapter *psAdapter);
+
 INT BcmDeAllocFlashCSStructure(struct bcm_mini_adapter *psAdapter);
 
 INT BcmCopyISO(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_copy_section sCopySectStrut);
+
 INT BcmFlash2xCorruptSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val eFlash2xSectionVal);
+
 INT BcmFlash2xWriteSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val eFlashSectionVal);
-INT	validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_readwrite *psFlash2xReadWrite);
+
+INT validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_readwrite *psFlash2xReadWrite);
+
 INT IsFlash2x(struct bcm_mini_adapter *Adapter);
-INT	BcmCopySection(struct bcm_mini_adapter *Adapter,
+
+INT BcmCopySection(struct bcm_mini_adapter *Adapter,
 						enum bcm_flash2x_section_val SrcSection,
 						enum bcm_flash2x_section_val DstSection,
 						UINT offset,
 						UINT numOfBytes);
 
-
 bool IsNonCDLessDevice(struct bcm_mini_adapter *Adapter);
 
+VOID OverrideServiceFlowParams(struct bcm_mini_adapter *Adapter, PUINT puiBuffer);
 
-VOID OverrideServiceFlowParams(struct bcm_mini_adapter *Adapter,PUINT puiBuffer);
+int wrmaltWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int wrmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
-int rdmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int rdmaltWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
 int wrmWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t size);
+
 INT buffDnldVerify(struct bcm_mini_adapter *Adapter, unsigned char *mappedbuffer, unsigned int u32FirmwareLength,
 		unsigned long u32StartingAddress);
 
-
 VOID putUsbSuspend(struct work_struct *work);
-bool IsReqGpioIsLedInNVM(struct bcm_mini_adapter *Adapter, UINT gpios);
 
+bool IsReqGpioIsLedInNVM(struct bcm_mini_adapter *Adapter, UINT gpios);
 
 #endif
-
-
-
-
-- 
1.9.1

