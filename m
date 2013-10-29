Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3J2DwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:52:11 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40191 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3J2DwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:02 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 06/11 V2] Staging: bcm: Replace B_UINT16 with u16 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:43 -0400
Message-Id: <1383018708-29615-7-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "B_UINT16" with "u16"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index a5dab86..01788d3 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -62,7 +62,7 @@ struct bcm_hdr_suppression_contextinfo {
 struct bcm_classifier_rule {
 	unsigned long ulSFID;
 	u8	ucReserved[2];
-	B_UINT16	uiClassifierRuleIndex;
+	u16	uiClassifierRuleIndex;
 	bool		bUsed;
 	unsigned short	usVCID_Value;
 	B_UINT8		u8ClassifierRulePriority; /* This field detemines the Classifier Priority */
@@ -204,7 +204,7 @@ struct bcm_tarang_data {
 
 struct bcm_targetdsx_buffer {
 	unsigned long	ulTargetDsxBuffer;
-	B_UINT16	tid;
+	u16	tid;
 	bool		valid;
 };
 
-- 
1.7.9.5

