Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3G0Tfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:35:31 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38324 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3G0Tf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:35:26 -0400
From: Lilis Iskandar <veeableful@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tulinizer@gmail.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Lilis Iskandar <veeableful@gmail.com>
Subject: [PATCH v2 4/5] Staging: bcm: LeakyBucket: Fixed code indent issues
Date: Sun, 28 Jul 2013 03:34:46 +0800
Message-Id: <1374953687-14386-4-git-send-email-veeableful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
References: <1374953687-14386-1-git-send-email-veeableful@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed code indent issues

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

