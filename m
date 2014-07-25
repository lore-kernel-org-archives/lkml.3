Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934815AbaGYPj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:39:58 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58293 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934710AbaGYPjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:39:53 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from channel.h
Date: Fri, 25 Jul 2014 18:39:36 +0300
Message-Id: <1406302776-31027-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from channel.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/channel.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/vt6655/channel.h b/drivers/staging/vt6655/channel.h
index c9931d7..4f44c8a 100644
--- a/drivers/staging/vt6655/channel.h
+++ b/drivers/staging/vt6655/channel.h
@@ -26,8 +26,6 @@
 #include "ttype.h"
 #include "card.h"
 
-/*---------------------  Export Classes  ----------------------------*/
-
 typedef struct tagSChannelTblElement {
 	unsigned char byChannelNumber;
 	unsigned int uFrequency;
@@ -35,8 +33,6 @@ typedef struct tagSChannelTblElement {
 	unsigned char byMAP;
 } SChannelTblElement, *PSChannelTblElement;
 
-/*---------------------  Export Functions  --------------------------*/
-
 bool is_channel_valid(unsigned int CountryCode);
 void init_channel_table(void *pDeviceHandler);
 unsigned char get_channel_mapping(void *pDeviceHandler, unsigned char byChannelNumber, CARD_PHY_TYPE ePhyType);
-- 
1.7.9.5

