Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3JGG5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 02:57:38 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33378 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab3JGG5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 02:57:37 -0400
Date: Mon, 7 Oct 2013 14:56:37 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: trivial@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH TRIVIAL] net: correct typos in comments
Message-ID: <20131007065637.GA10624@will>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 include/linux/netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3de49ac..0dd6de7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -366,7 +366,7 @@ typedef enum gro_result gro_result_t;
  * Upon return, rx_handler is expected to tell __netif_receive_skb() what to
  * do with the skb.
  *
- * If the rx_handler consumed to skb in some way, it should return
+ * If the rx_handler consumed the skb in some way, it should return
  * RX_HANDLER_CONSUMED. This is appropriate when the rx_handler arranged for
  * the skb to be delivered in some other ways.
  *
@@ -378,7 +378,7 @@ typedef enum gro_result gro_result_t;
  * RX_HANDLER_EXACT. The skb will only be delivered to protocol handlers that
  * are registered on exact device (ptype->dev == skb->dev).
  *
- * If the rx_handler didn't changed skb->dev, but want the skb to be normally
+ * If the rx_handler didn't change skb->dev, but want the skb to be normally
  * delivered, it should return RX_HANDLER_PASS.
  *
  * A device without a registered rx_handler will behave as if rx_handler
-- 
1.8.3.1

