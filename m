Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab3JZGP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 02:15:56 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:44646 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab3JZGPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 02:15:32 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 06/11] Staging: bcm: Replace B_UINT16 with u16 in Adapter.h
Date: Sat, 26 Oct 2013 02:15:15 -0400
Message-Id: <1382768120-23380-6-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
References: <1382768120-23380-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace "B_UINT16" with "u16"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 4c9662b..fbd06a1 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -62,7 +62,7 @@ struct bcm_hdr_suppression_contextinfo {
 struct bcm_classifier_rule {
 	unsigned long	ulSFID;
 	unsigned char	ucReserved[2];
-	B_UINT16	uiClassifierRuleIndex;
+	u16 uiClassifierRuleIndex;
 	BOOLEAN		bUsed;
 	unsigned short	usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
@@ -204,7 +204,7 @@ struct bcm_tarang_data {
 
 struct bcm_targetdsx_buffer {
 	unsigned long	ulTargetDsxBuffer;
-	B_UINT16	tid;
+	u16 tid;
 	BOOLEAN		valid;
 };
 
-- 
1.7.9.5

