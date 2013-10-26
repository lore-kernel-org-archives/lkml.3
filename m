Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3JZGP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:59 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:65273 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3JZGPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:33 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 07/11] Staging: bcm: Replace B_UINT8 with u8 in Adapter.h
Date: Sat, 26 Oct 2013 02:15:16 -0400
Message-Id: <1382768120-23380-7-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "B_UINT8" with "u8"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index fbd06a1..27b5011 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -65,7 +65,7 @@ struct bcm_classifier_rule {
 	u16 uiClassifierRuleIndex;
 	BOOLEAN		bUsed;
 	unsigned short	usVCID_Value;
-	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
+	u8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
 	unsigned char	ucIPSourceAddressLength; /* Ip Source Address Length */
 
@@ -126,13 +126,13 @@ struct bcm_packet_info {
 	unsigned short	usVCID_Value;
 	UINT		uiThreshold;
 	/* This field determines the priority of the SF Queues */
-	B_UINT8		u8TrafficPriority;
+	u8		u8TrafficPriority;
 
 	BOOLEAN		bValid;
 	BOOLEAN		bActive;
 	BOOLEAN		bActivateRequestSent;
 
-	B_UINT8		u8QueueType; /* BE or rtPS */
+	u8		u8QueueType; /* BE or rtPS */
 
 	UINT		uiMaxBucketSize; /* maximum size of the bucket for the queue */
 	UINT		uiCurrentQueueDepthOnTarget;
@@ -296,7 +296,7 @@ struct bcm_mini_adapter {
 	int			DDRSetting;
 	unsigned long		ulPowerSaveMode;
 	spinlock_t		txtransmitlock;
-	B_UINT8			txtransmit_running;
+	u8			txtransmit_running;
 	/* Thread for control packet handling */
 	struct task_struct	*control_packet_handler;
 	/* thread for transmitting packets. */
-- 
1.7.9.5

