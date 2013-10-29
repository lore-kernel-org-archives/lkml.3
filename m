Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290Ab3J2DwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:52:07 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:40001 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3J2DwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:02 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 07/11 V2] Staging: bcm: Replace B_UINT8 with u8 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:44 -0400
Message-Id: <1383018708-29615-8-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
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
index 01788d3..f7620ab 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -65,7 +65,7 @@ struct bcm_classifier_rule {
 	u16	uiClassifierRuleIndex;
 	bool		bUsed;
 	unsigned short	usVCID_Value;
-	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
+	u8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
 	union bcm_ip_address stSrcIpAddress;
 	u8	ucIPSourceAddressLength; /* Ip Source Address Length */
 
@@ -126,13 +126,13 @@ struct bcm_packet_info {
 	unsigned short	usVCID_Value;
 	UINT		uiThreshold;
 	/* This field determines the priority of the SF Queues */
-	B_UINT8		u8TrafficPriority;
+	u8		u8TrafficPriority;
 
 	bool		bValid;
 	bool		bActive;
 	bool		bActivateRequestSent;
 
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

