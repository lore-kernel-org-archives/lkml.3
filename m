Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaFTPtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:49:14 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33871 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbaFTPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:52 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 2/7] Staging: bcm: Prototypes.h: fix checkpatch errors: whitespaces
Date: Fri, 20 Jun 2014 17:37:59 +0200
Message-Id: <1403278684-10891-3-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Prototypes.h:
Whitespaces according to the coding guideline

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Prototypes.h | 58 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/bcm/Prototypes.h b/drivers/staging/bcm/Prototypes.h
index a8ddc6a..1ddc8b25 100644
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
 
@@ -29,19 +29,19 @@ VOID flush_all_queues(struct bcm_mini_adapter *Adapter);
 
 VOID PruneQueueAllSF(struct bcm_mini_adapter *Adapter);
 
-INT SearchSfid(struct bcm_mini_adapter *Adapter,UINT uiSfid);
+INT SearchSfid(struct bcm_mini_adapter *Adapter, UINT uiSfid);
 
-USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb);
+USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter, struct sk_buff *skb);
 
-bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
+bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPort);
 
-bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
+bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule, USHORT ushSrcPort);
 
-bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtocol);
+bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule, UCHAR ucProtocol);
 
 INT SetupNextSend(struct bcm_mini_adapter *Adapter, /**<Logical Adapter*/
 					struct sk_buff *Packet, /**<data buffer*/
-					USHORT Vcid)	;
+					USHORT Vcid);
 
 VOID LinkMessage(struct bcm_mini_adapter *Adapter);
 
@@ -63,9 +63,9 @@ INT FreeAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
 
 int tx_pkt_handler(struct bcm_mini_adapter *Adapter);
 
-int  reset_card_proc(struct bcm_mini_adapter *Adapter );
+int reset_card_proc(struct bcm_mini_adapter *Adapter);
 
-int run_card_proc(struct bcm_mini_adapter *Adapter );
+int run_card_proc(struct bcm_mini_adapter *Adapter);
 
 int InitCardAndDownloadFirmware(struct bcm_mini_adapter *ps_adapter);
 
@@ -79,15 +79,15 @@ int rdm(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t
 
 int wrm(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t size);
 
-int wrmalt (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int wrmalt(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int rdmalt (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int rdmalt(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int get_dsx_sf_data_to_application(struct bcm_mini_adapter *Adapter, UINT uiSFId, void __user * user_buffer);
+int get_dsx_sf_data_to_application(struct bcm_mini_adapter *Adapter, UINT uiSFId, void __user *user_buffer);
 
 void SendIdleModeResponse(struct bcm_mini_adapter *Adapter);
 
-int  ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *buf);
+int ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *buf);
 
 void GetDroppedAppCntrlPktMibs(struct bcm_host_stats_mibs *ioBuffer, struct bcm_tarang_data *pTarang);
 
@@ -102,17 +102,17 @@ VOID ResetCounters(struct bcm_mini_adapter *Adapter);
 
 int InitLedSettings(struct bcm_mini_adapter *Adapter);
 
-struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter,USHORT usIpIdentification,ULONG SrcIP);
+struct bcm_classifier_rule *GetFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIP);
 
 void AddFragIPClsEntry(struct bcm_mini_adapter *Adapter, struct bcm_fragmented_packet_info *psFragPktInfo);
 
-void DelFragIPClsEntry(struct bcm_mini_adapter *Adapter,USHORT usIpIdentification,ULONG SrcIp);
+void DelFragIPClsEntry(struct bcm_mini_adapter *Adapter, USHORT usIpIdentification, ULONG SrcIp);
 
-void update_per_cid_rx (struct bcm_mini_adapter *Adapter);
+void update_per_cid_rx(struct bcm_mini_adapter *Adapter);
 
-void update_per_sf_desc_cnts( struct bcm_mini_adapter *Adapter);
+void update_per_sf_desc_cnts(struct bcm_mini_adapter *Adapter);
 
-void ClearTargetDSXBuffer(struct bcm_mini_adapter *Adapter,B_UINT16 TID,bool bFreeAll);
+void ClearTargetDSXBuffer(struct bcm_mini_adapter *Adapter, B_UINT16 TID, bool bFreeAll);
 
 void flush_queue(struct bcm_mini_adapter *Adapter, UINT iQIndex);
 
@@ -124,7 +124,7 @@ INT BeceemEEPROMBulkRead(
 	UINT uiOffset,
 	UINT uiNumBytes);
 
-INT WriteBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT uiEEPROMOffset, UINT uiData);
+INT WriteBeceemEEPROM(struct bcm_mini_adapter *Adapter, UINT uiEEPROMOffset, UINT uiData);
 
 INT PropagateCalParamsFromFlashToMemory(struct bcm_mini_adapter *Adapter);
 
@@ -135,7 +135,7 @@ INT BeceemEEPROMBulkWrite(
 	UINT uiNumBytes,
 	bool bVerify);
 
-INT ReadBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT dwAddress, UINT *pdwData);
+INT ReadBeceemEEPROM(struct bcm_mini_adapter *Adapter, UINT dwAddress, UINT *pdwData);
 
 INT BeceemNVMRead(
 	struct bcm_mini_adapter *Adapter,
@@ -152,7 +152,7 @@ INT BeceemNVMWrite(
 
 INT BcmInitNVM(struct bcm_mini_adapter *Adapter);
 
-INT BcmUpdateSectorSize(struct bcm_mini_adapter *Adapter,UINT uiSectorSize);
+INT BcmUpdateSectorSize(struct bcm_mini_adapter *Adapter, UINT uiSectorSize);
 
 bool IsSectionExistInFlash(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val section);
 
@@ -187,11 +187,11 @@ INT BcmFlash2xCorruptSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_sect
 
 INT BcmFlash2xWriteSig(struct bcm_mini_adapter *Adapter, enum bcm_flash2x_section_val eFlashSectionVal);
 
-INT	validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_readwrite *psFlash2xReadWrite);
+INT validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_readwrite *psFlash2xReadWrite);
 
 INT IsFlash2x(struct bcm_mini_adapter *Adapter);
 
-INT	BcmCopySection(struct bcm_mini_adapter *Adapter,
+INT BcmCopySection(struct bcm_mini_adapter *Adapter,
 						enum bcm_flash2x_section_val SrcSection,
 						enum bcm_flash2x_section_val DstSection,
 						UINT offset,
@@ -199,11 +199,11 @@ INT	BcmCopySection(struct bcm_mini_adapter *Adapter,
 
 bool IsNonCDLessDevice(struct bcm_mini_adapter *Adapter);
 
-VOID OverrideServiceFlowParams(struct bcm_mini_adapter *Adapter,PUINT puiBuffer);
+VOID OverrideServiceFlowParams(struct bcm_mini_adapter *Adapter, PUINT puiBuffer);
 
-int wrmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int wrmaltWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
-int rdmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+int rdmaltWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
 int wrmWithLock(struct bcm_mini_adapter *Adapter, UINT uiAddress, PCHAR pucBuff, size_t size);
 
-- 
1.9.1

