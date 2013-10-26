Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3JZGPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:53 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:49865 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3JZGPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:30 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 04/11] Staging: bcm: Replace UCHAR with unsigned char in Adapter.h
Date: Sat, 26 Oct 2013 02:15:13 -0400
Message-Id: <1382768120-23380-4-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace "UCHAR" with "unsigned
char" in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |   82 ++++++++++++++++++++---------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 8f0033a..eaf9532 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -10,13 +10,13 @@
 struct bcm_leader {
 	unsigned short Vcid;
 	unsigned short PLength;
-	UCHAR	Status;
-	UCHAR	Unused[3];
+	unsigned char  Status;
+	unsigned char  Unused[3];
 } __packed;
 
 struct bcm_packettosend {
 	struct bcm_leader Leader;
-	UCHAR	ucPayload;
+	unsigned char ucPayload;
 } __packed;
 
 struct bcm_control_packet {
@@ -27,7 +27,7 @@ struct bcm_control_packet {
 
 struct bcm_link_request {
 	struct bcm_leader Leader;
-	UCHAR	szData[4];
+	unsigned char szData[4];
 } __packed;
 
 #define MAX_IP_RANGE_LENGTH 4
@@ -45,46 +45,46 @@ union bcm_ip_address {
 		ULONG ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4]; /* Source Ip Mask Address Range */
 	};
 	struct {
-		UCHAR ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
-		UCHAR ucIpv4Mask[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
+		unsigned char ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
+		unsigned char ucIpv4Mask[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
 	};
 	struct {
-		UCHAR ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
-		UCHAR ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
+		unsigned char ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
+		unsigned char ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 	};
 };
 
 struct bcm_hdr_suppression_contextinfo {
-	UCHAR ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
-	UCHAR ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
+	unsigned char ucaHdrSuppressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
+	unsigned char ucaHdrSuppressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
 };
 
 struct bcm_classifier_rule {
 	ULONG		ulSFID;
-	UCHAR		ucReserved[2];
+	unsigned char	ucReserved[2];
 	B_UINT16	uiClassifierRuleIndex;
 	BOOLEAN		bUsed;
 	unsigned short	usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
-	UCHAR		ucIPSourceAddressLength; /* Ip Source Address Length */
+	unsigned char	ucIPSourceAddressLength; /* Ip Source Address Length */
 
 	union bcm_ip_address stDestIpAddress;
-	UCHAR		ucIPDestinationAddressLength; /* Ip Destination Address Length */
-	UCHAR		ucIPTypeOfServiceLength; /* Type of service Length */
-	UCHAR		ucTosLow; /* Tos Low */
-	UCHAR		ucTosHigh; /* Tos High */
-	UCHAR		ucTosMask; /* Tos Mask */
-
-	UCHAR		ucProtocolLength; /* protocol Length */
-	UCHAR		ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
+	unsigned char	ucIPDestinationAddressLength; /* Ip Destination Address Length */
+	unsigned char	ucIPTypeOfServiceLength; /* Type of service Length */
+	unsigned char	ucTosLow; /* Tos Low */
+	unsigned char	ucTosHigh; /* Tos High */
+	unsigned char	ucTosMask; /* Tos Mask */
+
+	unsigned char	ucProtocolLength; /* protocol Length */
+	unsigned char	ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
 	unsigned short	usSrcPortRangeLo[MAX_PORT_RANGE];
 	unsigned short	usSrcPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucSrcPortRangeLength;
+	unsigned char	ucSrcPortRangeLength;
 
 	unsigned short	usDestPortRangeLo[MAX_PORT_RANGE];
 	unsigned short	usDestPortRangeHi[MAX_PORT_RANGE];
-	UCHAR		ucDestPortRangeLength;
+	unsigned char	ucDestPortRangeLength;
 
 	BOOLEAN		bProtocolValid;
 	BOOLEAN		bTOSValid;
@@ -92,22 +92,22 @@ struct bcm_classifier_rule {
 	BOOLEAN		bSrcIpValid;
 
 	/* For IPv6 Addressing */
-	UCHAR		ucDirection;
+	unsigned char	ucDirection;
 	BOOLEAN		bIpv6Protocol;
 	UINT32		u32PHSRuleID;
 	struct bcm_phs_rule sPhsRule;
-	UCHAR		u8AssociatedPHSI;
+	unsigned char		u8AssociatedPHSI;
 
 	/* Classification fields for ETH CS */
-	UCHAR		ucEthCSSrcMACLen;
-	UCHAR		au8EThCSSrcMAC[MAC_ADDRESS_SIZE];
-	UCHAR		au8EThCSSrcMACMask[MAC_ADDRESS_SIZE];
-	UCHAR		ucEthCSDestMACLen;
-	UCHAR		au8EThCSDestMAC[MAC_ADDRESS_SIZE];
-	UCHAR		au8EThCSDestMACMask[MAC_ADDRESS_SIZE];
-	UCHAR		ucEtherTypeLen;
-	UCHAR		au8EthCSEtherType[NUM_ETHERTYPE_BYTES];
-	UCHAR		usUserPriority[2];
+	unsigned char	ucEthCSSrcMACLen;
+	unsigned char	au8EThCSSrcMAC[MAC_ADDRESS_SIZE];
+	unsigned char	au8EThCSSrcMACMask[MAC_ADDRESS_SIZE];
+	unsigned char	ucEthCSDestMACLen;
+	unsigned char	au8EThCSDestMAC[MAC_ADDRESS_SIZE];
+	unsigned char	au8EThCSDestMACMask[MAC_ADDRESS_SIZE];
+	unsigned char	ucEtherTypeLen;
+	unsigned char	au8EthCSEtherType[NUM_ETHERTYPE_BYTES];
+	unsigned char	usUserPriority[2];
 	unsigned short	usVLANID;
 	unsigned short	usValidityBitMap;
 };
@@ -149,7 +149,7 @@ struct bcm_packet_info {
 	LARGE_INTEGER	liLastUpdateTokenAt;
 	UINT		uiMaxAllowedRate;
 	UINT		NumOfPacketsSent;
-	UCHAR		ucDirection;
+	unsigned char	ucDirection;
 	unsigned short	usCID;
 	struct bcm_mibs_parameters stMibsExtServiceFlowTable;
 	UINT		uiCurrentRxRate;
@@ -157,7 +157,7 @@ struct bcm_packet_info {
 	UINT		uiTotalRxBytes;
 	UINT		uiTotalTxBytes;
 	UINT		uiPendedLast;
-	UCHAR		ucIpVersion;
+	unsigned char	ucIpVersion;
 
 	union {
 		struct {
@@ -179,15 +179,15 @@ struct bcm_packet_info {
 	BOOLEAN		bAdmittedSet;
 	BOOLEAN		bAuthorizedSet;
 	BOOLEAN		bClassifierPriority;
-	UCHAR		ucServiceClassName[MAX_CLASS_NAME_LENGTH];
+	unsigned char	ucServiceClassName[MAX_CLASS_NAME_LENGTH];
 	BOOLEAN		bHeaderSuppressionEnabled;
 	spinlock_t	SFQueueLock;
 	void		*pstSFIndication;
 	struct timeval	stLastUpdateTokenAt;
 	atomic_t	uiPerSFTxResourceCount;
 	UINT		uiMaxLatency;
-	UCHAR		bIPCSSupport;
-	UCHAR		bEthCSSupport;
+	unsigned char	bIPCSSupport;
+	unsigned char	bEthCSSupport;
 };
 
 struct bcm_tarang_data {
@@ -255,7 +255,7 @@ struct bcm_mini_adapter {
 	BOOLEAN			bETHCSEnabled;
 	ULONG			BEBucketSize;
 	ULONG			rtPSBucketSize;
-	UCHAR			LinkStatus;
+	unsigned char		LinkStatus;
 	BOOLEAN			AutoLinkUp;
 	BOOLEAN			AutoSyncup;
 
@@ -398,8 +398,8 @@ struct bcm_mini_adapter {
 #define GET_BCM_ADAPTER(net_dev) netdev_priv(net_dev)
 
 struct bcm_eth_header {
-	UCHAR	au8DestinationAddress[6];
-	UCHAR	au8SourceAddress[6];
+	unsigned char	au8DestinationAddress[6];
+	unsigned char	au8SourceAddress[6];
 	unsigned short u16Etype;
 } __packed;
 
-- 
1.7.9.5

