Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3G0Tfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:35:46 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37955 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab3G0Tf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:35:29 -0400
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tulinizer@gmail.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Lilis Iskandar <veeableful@gmail.com>
Subject: [PATCH v2 5/5] Staging: bcm: LeakyBucket: Fixed a pointer asterisk placement issue
Date: Sun, 28 Jul 2013 03:34:47 +0800
Message-Id: <1374953687-14386-5-git-send-email-veeableful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
References: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a pointer asterisk placement issue

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index fb18ae0..bc48616 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -104,7 +104,7 @@ This function despatches packet from the specified queue.
 */
 static INT SendPacketFromQueue(struct bcm_mini_adapter *Adapter,/**<Logical Adapter*/
 			struct bcm_packet_info *psSF, /**<Queue identifier*/
-			       struct sk_buff*  Packet)	/**<Pointer to the packet to be sent*/
+			       struct sk_buff *Packet)	/**<Pointer to the packet to be sent*/
 {
 	INT Status = STATUS_FAILURE;
 	UINT uiIndex = 0, PktLen = 0;
-- 
1.8.3.1

