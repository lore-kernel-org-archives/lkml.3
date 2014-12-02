Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaLBXwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:52:23 -0500
Received: from blu004-omc1s38.hotmail.com ([65.55.116.49]:62598 "EHLO
	BLU004-OMC1S38.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932722AbaLBXwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:52:22 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 18:52:21 EST
X-TMN: [FV9+FaF0uxyZuNJK5/85OTEztp/J4Lb3]
X-Originating-Email: [seancleator@hotmail.co.uk]
Message-ID: <BLU436-SMTP148E68C36A6855503BCB5FFE97A0@phx.gbl>
From: Sean Cleator <seancleator@hotmail.co.uk>
To: gregkh@linuxfoundation.org
CC: Lior Dotan <liodot@gmail.com>, Christopher Harrer <charrer@alacritech.com>,
        David Matlack <matlackdavid@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>,
        Sean Cleator <seancleator@hotmail.co.uk>,
        Vincent Heuken <me@vincentheuken.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: slicoss: Fix long line issues in slicoss.c 
Date: Tue, 2 Dec 2014 23:45:00 +0000
X-Mailer: git-send-email 2.1.3
X-OriginalArrivalTime: 02 Dec 2014 23:44:19.0920 (UTC) FILETIME=[E469ED00:01D00E89]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 A patch to the slicoss.c file to fix some of the long line issues found by the
 checkpath.pl tool 
 Signed-off-by: Sean Cleator <seancleator@hotmail.co.uk>

---
 drivers/staging/slicoss/slicoss.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 56ca3b6..4df4a7e 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -498,12 +498,14 @@ static int slic_card_download(struct adapter *adapter)
 			slic_reg32_write(&slic_regs->slic_wcs,
 					 baseaddress + codeaddr, FLUSH);
 			/* Write out instruction to low addr */
-			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
+			slic_reg32_write(&slic_regs->slic_wcs,
+					instruction, FLUSH);
 			instruction = *(u32 *)(fw->data + index);
 			index += 4;
 
 			/* Write out instruction to high addr */
-			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
+			slic_reg32_write(&slic_regs->slic_wcs,
+					instruction, FLUSH);
 			instruction = *(u32 *)(fw->data + index);
 			index += 4;
 		}
@@ -1533,14 +1535,18 @@ retry_rcvqfill:
 				dev_err(dev, "%s: LOW 32bits PHYSICAL ADDRESS == 0\n",
 					__func__);
 				dev_err(dev, "skb[%p] PROBLEM\n", skb);
-				dev_err(dev, "         skbdata[%p]\n", skb->data);
+				dev_err(dev, "         skbdata[%p]\n",
+						skb->data);
 				dev_err(dev, "         skblen[%x]\n", skb->len);
 				dev_err(dev, "         paddr[%p]\n", paddr);
 				dev_err(dev, "         paddrl[%x]\n", paddrl);
 				dev_err(dev, "         paddrh[%x]\n", paddrh);
-				dev_err(dev, "         rcvq->head[%p]\n", rcvq->head);
-				dev_err(dev, "         rcvq->tail[%p]\n", rcvq->tail);
-				dev_err(dev, "         rcvq->count[%x]\n", rcvq->count);
+				dev_err(dev, "         rcvq->head[%p]\n",
+						rcvq->head);
+				dev_err(dev, "         rcvq->tail[%p]\n",
+						rcvq->tail);
+				dev_err(dev, "         rcvq->count[%x]\n",
+						rcvq->count);
 				dev_err(dev, "SKIP THIS SKB!!!!!!!!\n");
 				goto retry_rcvqfill;
 			}
@@ -1549,14 +1555,18 @@ retry_rcvqfill:
 				dev_err(dev, "%s: LOW 32bits PHYSICAL ADDRESS == 0\n",
 					__func__);
 				dev_err(dev, "skb[%p] PROBLEM\n", skb);
-				dev_err(dev, "         skbdata[%p]\n", skb->data);
+				dev_err(dev, "         skbdata[%p]\n",
+						skb->data);
 				dev_err(dev, "         skblen[%x]\n", skb->len);
 				dev_err(dev, "         paddr[%p]\n", paddr);
 				dev_err(dev, "         paddrl[%x]\n", paddrl);
 				dev_err(dev, "         paddrh[%x]\n", paddrh);
-				dev_err(dev, "         rcvq->head[%p]\n", rcvq->head);
-				dev_err(dev, "         rcvq->tail[%p]\n", rcvq->tail);
-				dev_err(dev, "         rcvq->count[%x]\n", rcvq->count);
+				dev_err(dev, "         rcvq->head[%p]\n",
+						rcvq->head);
+				dev_err(dev, "         rcvq->tail[%p]\n",
+						rcvq->tail);
+				dev_err(dev, "         rcvq->count[%x]\n",
+						rcvq->count);
 				dev_err(dev, "GIVE TO CARD ANYWAY\n");
 			}
 #endif
@@ -1885,7 +1895,8 @@ static void slic_xmit_fail(struct adapter *adapter,
 			break;
 		case XMIT_FAIL_HOSTCMD_FAIL:
 			dev_err(&adapter->netdev->dev,
-				"xmit_start skb[%p] type[%x] No host commands available\n", skb, skb->pkt_type);
+				"xmit_start skb[%p] type[%x] No host commands available\n",
+				skb, skb->pkt_type);
 			break;
 		}
 	}
@@ -2097,7 +2108,8 @@ static void slic_interrupt_card_up(u32 isr, struct adapter *adapter,
 				}
 			} else if (isr & ISR_XDROP) {
 				dev_err(&dev->dev,
-						"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
+						"isr & ISR_ERR [%x] ISR_XDROP\n",
+						isr);
 			} else {
 				dev_err(&dev->dev,
 						"isr & ISR_ERR [%x]\n",
@@ -2341,7 +2353,8 @@ static int slic_if_init(struct adapter *adapter)
 				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
 #else
 		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
-		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
+		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr,
+				FLUSH);
 #endif
 		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
 					adapter->bit64reglock.flags);
-- 
2.1.3

