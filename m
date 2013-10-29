Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab3J2Dxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:53:55 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50648 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932251Ab3J2DwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:04 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 09/11 V2] Staging: bcm: Replace UINT with unsigned int in Adapter.h
Date: Mon, 28 Oct 2013 23:51:46 -0400
Message-Id: <1383018708-29615-10-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "UINT" with "unsigned
int" in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   84 ++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 35f480a..32343e3 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -21,7 +21,7 @@ struct bcm_packettosend {
 
 struct bcm_control_packet {
 	PVOID	ControlBuff;
-	UINT	ControlBuffLen;
+	unsigned int ControlBuffLen;
 	struct bcm_control_packet *next;
 } __packed;
 
@@ -124,7 +124,7 @@ struct bcm_packet_info {
 	/* classification extension Rule */
 	unsigned long	ulSFID;
 	unsigned short	usVCID_Value;
-	UINT		uiThreshold;
+	unsigned int	uiThreshold;
 	/* This field determines the priority of the SF Queues */
 	u8		u8TrafficPriority;
 
@@ -134,29 +134,29 @@ struct bcm_packet_info {
 
 	u8		u8QueueType; /* BE or rtPS */
 
-	UINT		uiMaxBucketSize; /* maximum size of the bucket for the queue */
-	UINT		uiCurrentQueueDepthOnTarget;
-	UINT		uiCurrentBytesOnHost;
-	UINT		uiCurrentPacketsOnHost;
-	UINT		uiDroppedCountBytes;
-	UINT		uiDroppedCountPackets;
-	UINT		uiSentBytes;
-	UINT		uiSentPackets;
-	UINT		uiCurrentDrainRate;
-	UINT		uiThisPeriodSentBytes;
+	unsigned int	uiMaxBucketSize; /* maximum size of the bucket for the queue */
+	unsigned int	uiCurrentQueueDepthOnTarget;
+	unsigned int	uiCurrentBytesOnHost;
+	unsigned int	uiCurrentPacketsOnHost;
+	unsigned int	uiDroppedCountBytes;
+	unsigned int	uiDroppedCountPackets;
+	unsigned int	uiSentBytes;
+	unsigned int	uiSentPackets;
+	unsigned int	uiCurrentDrainRate;
+	unsigned int	uiThisPeriodSentBytes;
 	LARGE_INTEGER	liDrainCalculated;
-	UINT		uiCurrentTokenCount;
+	unsigned int	uiCurrentTokenCount;
 	LARGE_INTEGER	liLastUpdateTokenAt;
-	UINT		uiMaxAllowedRate;
-	UINT		NumOfPacketsSent;
+	unsigned int	uiMaxAllowedRate;
+	unsigned int	NumOfPacketsSent;
 	u8	ucDirection;
 	unsigned short	usCID;
 	struct bcm_mibs_parameters stMibsExtServiceFlowTable;
-	UINT		uiCurrentRxRate;
-	UINT		uiThisPeriodRxBytes;
-	UINT		uiTotalRxBytes;
-	UINT		uiTotalTxBytes;
-	UINT		uiPendedLast;
+	unsigned int	uiCurrentRxRate;
+	unsigned int	uiThisPeriodRxBytes;
+	unsigned int	uiTotalRxBytes;
+	unsigned int	uiTotalTxBytes;
+	unsigned int	uiPendedLast;
 	u8	ucIpVersion;
 
 	union {
@@ -185,7 +185,7 @@ struct bcm_packet_info {
 	void		*pstSFIndication;
 	struct timeval	stLastUpdateTokenAt;
 	atomic_t	uiPerSFTxResourceCount;
-	UINT		uiMaxLatency;
+	unsigned int	uiMaxLatency;
 	u8	bIPCSSupport;
 	u8	bEthCSSupport;
 };
@@ -208,9 +208,9 @@ struct bcm_targetdsx_buffer {
 	bool		valid;
 };
 
-typedef int (*FP_FLASH_WRITE)(struct bcm_mini_adapter *, UINT, PVOID);
+typedef int (*FP_FLASH_WRITE)(struct bcm_mini_adapter *, unsigned int, PVOID);
 
-typedef int (*FP_FLASH_WRITE_STATUS)(struct bcm_mini_adapter *, UINT, PVOID);
+typedef int (*FP_FLASH_WRITE_STATUS)(struct bcm_mini_adapter *, unsigned int, PVOID);
 
 /*
  * Driver adapter data structure
@@ -246,7 +246,7 @@ struct bcm_mini_adapter {
 	/* to keep track the no of byte received */
 	unsigned short		PrevNumRecvDescs;
 	unsigned short		CurrNumRecvDescs;
-	UINT			u32TotalDSD;
+	unsigned int		u32TotalDSD;
 	struct bcm_packet_info	PackInfo[NO_OF_QUEUES];
 	struct bcm_classifier_rule astClassifierTable[MAX_CLASSIFIERS];
 	bool			TransferMode;
@@ -271,7 +271,7 @@ struct bcm_mini_adapter {
 	atomic_t		index_app_read_cntrlpkt;
 	atomic_t		index_wr_txcntrlpkt;
 	atomic_t		index_rd_txcntrlpkt;
-	UINT			index_datpkt;
+	unsigned int		index_datpkt;
 	struct semaphore	rdmwrmsync;
 
 	struct bcm_targetdsx_buffer	astTargetDsxBuffer[MAX_TARGET_DSX_BUFFERS];
@@ -316,14 +316,14 @@ struct bcm_mini_adapter {
 					struct file *,
 					unsigned int);
 	int (*interface_rdm)(PVOID,
-			UINT,
+			unsigned int,
 			PVOID,
 			int);
 	int (*interface_wrm)(PVOID,
-			UINT,
+			unsigned int,
 			PVOID,
 			int);
-	int (*interface_transmit)(PVOID, PVOID , UINT);
+	int (*interface_transmit)(PVOID, PVOID , unsigned int);
 	bool			IdleMode;
 	bool			bDregRequestSentInIdleMode;
 	bool			bTriedToWakeUpFromlowPowerMode;
@@ -346,16 +346,16 @@ struct bcm_mini_adapter {
 	atomic_t		uiMBupdate;
 	u32			PmuMode;
 	enum bcm_nvm_type	eNVMType;
-	UINT			uiSectorSize;
-	UINT			uiSectorSizeInCFG;
+	unsigned int		uiSectorSize;
+	unsigned int		uiSectorSizeInCFG;
 	bool			bSectorSizeOverride;
 	bool			bStatusWrite;
-	UINT			uiNVMDSDSize;
-	UINT			uiVendorExtnFlag;
+	unsigned int		uiNVMDSDSize;
+	unsigned int		uiVendorExtnFlag;
 	/* it will always represent chosen DSD at any point of time.
 	 * Generally it is Active DSD but in case of NVM RD/WR it might be different.
 	 */
-	UINT			ulFlashCalStart;
+	unsigned int		ulFlashCalStart;
 	unsigned long		ulFlashControlSectionStart;
 	unsigned long		ulFlashWriteSize;
 	unsigned long		ulFlashID;
@@ -369,13 +369,13 @@ struct bcm_mini_adapter {
 	struct bcm_flash2x_cs_info *psFlash2xCSInfo;
 	struct bcm_flash_cs_info *psFlashCSInfo;
 	struct bcm_flash2x_vendor_info *psFlash2xVendorInfo;
-	UINT			uiFlashBaseAdd; /* Flash start address */
-	UINT			uiActiveISOOffset; /* Active ISO offset chosen before f/w download */
+	unsigned int		uiFlashBaseAdd; /* Flash start address */
+	unsigned int		uiActiveISOOffset; /* Active ISO offset chosen before f/w download */
 	enum bcm_flash2x_section_val eActiveISO; /* Active ISO section val */
 	enum bcm_flash2x_section_val eActiveDSD; /* Active DSD val chosen before f/w download */
-	UINT			uiActiveDSDOffsetAtFwDld;  /* For accessing Active DSD chosen before f/w download */
-	UINT			uiFlashLayoutMajorVersion;
-	UINT			uiFlashLayoutMinorVersion;
+	unsigned int		uiActiveDSDOffsetAtFwDld;  /* For accessing Active DSD chosen before f/w download */
+	unsigned int		uiFlashLayoutMajorVersion;
+	unsigned int		uiFlashLayoutMinorVersion;
 	bool			bAllDSDWriteAllow;
 	bool			bSigCorrupted;
 	/* this should be set who so ever want to change the Headers. after Wrtie it should be reset immediately. */
@@ -386,12 +386,12 @@ struct bcm_mini_adapter {
 	bool			bFlashRawRead;
 	bool			bPreparingForLowPowerMode;
 	bool			bDoSuspend;
-	UINT			syscfgBefFwDld;
+	unsigned int		syscfgBefFwDld;
 	bool			StopAllXaction;
 	u32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
 	unsigned long		liDrainCalculated;
-	UINT			gpioBitMap;
+	unsigned int		gpioBitMap;
 	struct bcm_debug_state	stDebugState;
 };
 
@@ -413,8 +413,8 @@ struct bcm_firmware_info {
 extern struct net_device *gblpnetdev;
 
 struct bcm_ddr_setting {
-	UINT ulRegAddress;
-	UINT ulRegValue;
+	unsigned int ulRegAddress;
+	unsigned int ulRegValue;
 };
 int InitAdapter(struct bcm_mini_adapter *psAdapter);
 
-- 
1.7.9.5

