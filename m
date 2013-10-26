Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3JZGP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:58 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:60496 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3JZGPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:31 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 05/11] Staging: bcm: Replace ULONG with unsigned long in Adapter.h
Date: Sat, 26 Oct 2013 02:15:14 -0400
Message-Id: <1382768120-23380-5-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace "ULONG" with "unsigned
long" in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   42 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index eaf9532..4c9662b 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -37,12 +37,12 @@ struct bcm_link_request {
 
 union bcm_ip_address {
 	struct {
-		ULONG ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
-		ULONG ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
+		unsigned long ulIpv4Addr[MAX_IP_RANGE_LENGTH]; /* Source Ip Address Range */
+		unsigned long ulIpv4Mask[MAX_IP_RANGE_LENGTH]; /* Source Ip Mask Address Range */
 	};
 	struct {
-		ULONG ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Address Range */
-		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
+		unsigned long ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Address Range */
+		unsigned long ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
 	};
 	struct {
 		unsigned char ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
@@ -60,7 +60,7 @@ struct bcm_hdr_suppression_contextinfo {
 };
 
 struct bcm_classifier_rule {
-	ULONG		ulSFID;
+	unsigned long	ulSFID;
 	unsigned char	ucReserved[2];
 	B_UINT16	uiClassifierRuleIndex;
 	BOOLEAN		bUsed;
@@ -114,7 +114,7 @@ struct bcm_classifier_rule {
 
 struct bcm_fragmented_packet_info {
 	BOOLEAN			bUsed;
-	ULONG			ulSrcIpAddress;
+	unsigned long		ulSrcIpAddress;
 	unsigned short usIpIdentification;
 	struct bcm_classifier_rule *pstMatchedClassifierEntry;
 	BOOLEAN			bOutOfOrderFragment;
@@ -122,7 +122,7 @@ struct bcm_fragmented_packet_info {
 
 struct bcm_packet_info {
 	/* classification extension Rule */
-	ULONG		ulSFID;
+	unsigned long	ulSFID;
 	unsigned short	usVCID_Value;
 	UINT		uiThreshold;
 	/* This field determines the priority of the SF Queues */
@@ -199,11 +199,11 @@ struct bcm_tarang_data {
 	BOOLEAN			MacTracingEnabled;
 	BOOLEAN			bApplicationToExit;
 	struct bcm_mibs_dropped_cntrl_msg stDroppedAppCntrlMsgs;
-	ULONG			RxCntrlMsgBitMask;
+	unsigned long		RxCntrlMsgBitMask;
 };
 
 struct bcm_targetdsx_buffer {
-	ULONG		ulTargetDsxBuffer;
+	unsigned long	ulTargetDsxBuffer;
 	B_UINT16	tid;
 	BOOLEAN		valid;
 };
@@ -253,8 +253,8 @@ struct bcm_mini_adapter {
 
 	/*************** qos ******************/
 	BOOLEAN			bETHCSEnabled;
-	ULONG			BEBucketSize;
-	ULONG			rtPSBucketSize;
+	unsigned long		BEBucketSize;
+	unsigned long		rtPSBucketSize;
 	unsigned char		LinkStatus;
 	BOOLEAN			AutoLinkUp;
 	BOOLEAN			AutoSyncup;
@@ -275,9 +275,9 @@ struct bcm_mini_adapter {
 	struct semaphore	rdmwrmsync;
 
 	struct bcm_targetdsx_buffer	astTargetDsxBuffer[MAX_TARGET_DSX_BUFFERS];
-	ULONG			ulFreeTargetBufferCnt;
-	ULONG			ulCurrentTargetBuffer;
-	ULONG			ulTotalTargetBuffersAvailable;
+	unsigned long		ulFreeTargetBufferCnt;
+	unsigned long		ulCurrentTargetBuffer;
+	unsigned long		ulTotalTargetBuffersAvailable;
 	unsigned long		chip_id;
 	wait_queue_head_t	lowpower_mode_wait_queue;
 	BOOLEAN			bFlashBoot;
@@ -294,7 +294,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			bIsAutoCorrectEnabled;
 	BOOLEAN			bDDRInitDone;
 	int			DDRSetting;
-	ULONG			ulPowerSaveMode;
+	unsigned long		ulPowerSaveMode;
 	spinlock_t		txtransmitlock;
 	B_UINT8			txtransmit_running;
 	/* Thread for control packet handling */
@@ -356,9 +356,9 @@ struct bcm_mini_adapter {
 	 * Generally it is Active DSD but in case of NVM RD/WR it might be different.
 	 */
 	UINT			ulFlashCalStart;
-	ULONG			ulFlashControlSectionStart;
-	ULONG			ulFlashWriteSize;
-	ULONG			ulFlashID;
+	unsigned long		ulFlashControlSectionStart;
+	unsigned long		ulFlashWriteSize;
+	unsigned long		ulFlashID;
 	FP_FLASH_WRITE		fpFlashWrite;
 	FP_FLASH_WRITE_STATUS	fpFlashWriteWithStatusCheck;
 
@@ -390,7 +390,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			StopAllXaction;
 	UINT32			liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
-	ULONG			liDrainCalculated;
+	unsigned long		liDrainCalculated;
 	UINT			gpioBitMap;
 	struct bcm_debug_state	stDebugState;
 };
@@ -405,8 +405,8 @@ struct bcm_eth_header {
 
 struct bcm_firmware_info {
 	void	__user *pvMappedFirmwareAddress;
-	ULONG	u32FirmwareLength;
-	ULONG	u32StartingAddress;
+	unsigned long	u32FirmwareLength;
+	unsigned long	u32StartingAddress;
 } __packed;
 
 /* holds the value of net_device structure.. */
-- 
1.7.9.5

