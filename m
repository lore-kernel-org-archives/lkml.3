Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab3GZOXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:23:19 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64638 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZOXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:23:17 -0400
Message-ID: <1374848591.13685.6.camel@desktop>
Subject: [PATCH 4/5] Staging: bcm: LeakyBucket: Fixed code indent issues
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jamesceri@googlemail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Jul 2013 22:23:11 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code indent issues.

Signed-off-by: Lilis Iskandar <veeableful@gmail.com>
---
 drivers/staging/bcm/LeakyBucket.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/bcm/LeakyBucket.c b/drivers/staging/bcm/LeakyBucket.c
index 75d77c2e..fb18ae0 100644
--- a/drivers/staging/bcm/LeakyBucket.c
+++ b/drivers/staging/bcm/LeakyBucket.c
@@ -187,7 +187,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 				atomic_dec(&Adapter->TotalPacketCount);
 				spin_unlock_bh(&psSF->SFQueueLock);
 
-			   	Status = SendPacketFromQueue(Adapter, psSF, QueuePacket);
+				Status = SendPacketFromQueue(Adapter, psSF, QueuePacket);
 				psSF->uiPendedLast = FALSE;
 			} else {
 				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, "For Queue: %zd\n", psSF-Adapter->PackInfo);
@@ -230,7 +230,7 @@ static VOID CheckAndSendPacketFromIndex(struct bcm_mini_adapter *Adapter, struct
 			} else {
 					BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, TX_PACKETS, DBG_LVL_ALL, " Control Pkt is not available, Indexing is wrong....");
 			}
-	   	}
+		}
 	}
 }
 
@@ -308,7 +308,7 @@ VOID transmit_packets(struct bcm_mini_adapter *Adapter)
 			break;
 		}
 		if (exit_flag == TRUE)
-		    break;
+			break;
 	} /* end of inner while loop */
 
 	update_per_cid_rx(Adapter);
-- 
1.8.3.1



