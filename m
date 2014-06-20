Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965756AbaFTP5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:57:24 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33868 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754882AbaFTPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:50 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 1/7] Staging: bcm: Prototypes.h: fix checkpatch errors: blank lines
Date: Fri, 20 Jun 2014 17:37:58 +0200
Message-Id: <1403278684-10891-2-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
References: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves coding style in Prototypes.h:
Exactly one blank line after each declaration

Signed-off-by: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
Signed-off-by: Christian Bay <christian.bay@studium.fau.de>
---
 drivers/staging/bcm/Prototypes.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/bcm/Prototypes.h b/drivers/staging/bcm/Prototypes.h
index fb53a00..a8ddc6a 100644
--- a/drivers/staging/bcm/Prototypes.h
+++ b/drivers/staging/bcm/Prototypes.h
@@ -34,9 +34,10 @@ INT SearchSfid(struct bcm_mini_adapter *Adapter,UINT uiSfid);
 USHORT ClassifyPacket(struct bcm_mini_adapter *Adapter,struct sk_buff* skb);
 
 bool MatchSrcPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
+
 bool MatchDestPort(struct bcm_classifier_rule *pstClassifierRule,USHORT ushSrcPort);
-bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtocol);
 
+bool MatchProtocol(struct bcm_classifier_rule *pstClassifierRule,UCHAR ucProtocol);
 
 INT SetupNextSend(struct bcm_mini_adapter *Adapter, /**<Logical Adapter*/
 					struct sk_buff *Packet, /**<data buffer*/
@@ -50,8 +51,8 @@ INT SendControlPacket(struct bcm_mini_adapter *Adapter, /**<Logical Adapter*/
 							char *pControlPacket/**<Control Packet*/
 							);
 
-
 int register_networkdev(struct bcm_mini_adapter *Adapter);
+
 void unregister_networkdev(struct bcm_mini_adapter *Adapter);
 
 INT AllocAdapterDsxBuffer(struct bcm_mini_adapter *Adapter);
@@ -68,7 +69,6 @@ int run_card_proc(struct bcm_mini_adapter *Adapter );
 
 int InitCardAndDownloadFirmware(struct bcm_mini_adapter *ps_adapter);
 
-
 INT ReadMacAddressFromNVM(struct bcm_mini_adapter *Adapter);
 
 int register_control_device_interface(struct bcm_mini_adapter *ps_adapter);
@@ -87,9 +87,10 @@ int get_dsx_sf_data_to_application(struct bcm_mini_adapter *Adapter, UINT uiSFId
 
 void SendIdleModeResponse(struct bcm_mini_adapter *Adapter);
 
-
 int  ProcessGetHostMibs(struct bcm_mini_adapter *Adapter, struct bcm_host_stats_mibs *buf);
+
 void GetDroppedAppCntrlPktMibs(struct bcm_host_stats_mibs *ioBuffer, struct bcm_tarang_data *pTarang);
+
 void beceem_parse_target_struct(struct bcm_mini_adapter *Adapter);
 
 int bcm_ioctl_fw_download(struct bcm_mini_adapter *Adapter, struct bcm_firmware_info *psFwInfo);
@@ -113,26 +114,20 @@ void update_per_sf_desc_cnts( struct bcm_mini_adapter *Adapter);
 
 void ClearTargetDSXBuffer(struct bcm_mini_adapter *Adapter,B_UINT16 TID,bool bFreeAll);
 
-
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
 INT WriteBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT uiEEPROMOffset, UINT uiData);
 
 INT PropagateCalParamsFromFlashToMemory(struct bcm_mini_adapter *Adapter);
 
-
 INT BeceemEEPROMBulkWrite(
 	struct bcm_mini_adapter *Adapter,
 	PUCHAR pBuffer,
@@ -140,10 +135,8 @@ INT BeceemEEPROMBulkWrite(
 	UINT uiNumBytes,
 	bool bVerify);
 
-
 INT ReadBeceemEEPROM(struct bcm_mini_adapter *Adapter,UINT dwAddress, UINT *pdwData);
 
-
 INT BeceemNVMRead(
 	struct bcm_mini_adapter *Adapter,
 	PUINT pBuffer,
@@ -157,10 +150,10 @@ INT BeceemNVMWrite(
 	UINT uiNumBytes,
 	bool bVerify);
 
-
 INT BcmInitNVM(struct bcm_mini_adapter *Adapter);
 
 INT BcmUpdateSectorSize(struct bcm_mini_adapter *Adapter,UINT uiSectorSize);
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
+
 INT	validateFlash2xReadWrite(struct bcm_mini_adapter *Adapter, struct bcm_flash2x_readwrite *psFlash2xReadWrite);
+
 INT IsFlash2x(struct bcm_mini_adapter *Adapter);
+
 INT	BcmCopySection(struct bcm_mini_adapter *Adapter,
 						enum bcm_flash2x_section_val SrcSection,
 						enum bcm_flash2x_section_val DstSection,
 						UINT offset,
 						UINT numOfBytes);
 
-
 bool IsNonCDLessDevice(struct bcm_mini_adapter *Adapter);
 
-
 VOID OverrideServiceFlowParams(struct bcm_mini_adapter *Adapter,PUINT puiBuffer);
 
 int wrmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
+
 int rdmaltWithLock (struct bcm_mini_adapter *Adapter, UINT uiAddress, unsigned int *pucBuff, size_t sSize);
 
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

