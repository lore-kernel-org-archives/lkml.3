Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060Ab3GZOYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:24:43 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52089 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab3GZOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:24:41 -0400
Message-ID: <1374848675.13685.8.camel@desktop>
Subject: [PATCH 5/5] Staging: bcm: LeakyBucket: Fixed a pointer asterisk
 placement issue
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jamesceri@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 22:24:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a pointer asterisk placement issue.

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



