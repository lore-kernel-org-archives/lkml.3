Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3J2Dwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:52:55 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:52697 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab3J2DwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:52:07 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 11/11 V2] Staging: bcm: Replace LARGE_INTEGER with u64 in Adapter.h
Date: Mon, 28 Oct 2013 23:51:48 -0400
Message-Id: <1383018708-29615-12-git-send-email-klmckinney1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
References: <1383018708-29615-1-git-send-email-klmckinney1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces "LARGE_INTEGER" with "u64"
in Adapter.h

Signed-off-by: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/Adapter.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 7055b83..c373bc0 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -144,9 +144,9 @@ struct bcm_packet_info {
 	unsigned int	uiSentPackets;
 	unsigned int	uiCurrentDrainRate;
 	unsigned int	uiThisPeriodSentBytes;
-	LARGE_INTEGER	liDrainCalculated;
+	u64		liDrainCalculated;
 	unsigned int	uiCurrentTokenCount;
-	LARGE_INTEGER	liLastUpdateTokenAt;
+	u64		liLastUpdateTokenAt;
 	unsigned int	uiMaxAllowedRate;
 	unsigned int	NumOfPacketsSent;
 	u8	ucDirection;
-- 
1.7.9.5

