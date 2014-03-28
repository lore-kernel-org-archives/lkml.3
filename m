Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaC1NnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:43:06 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54780 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaC1NnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:43:03 -0400
Message-ID: <53357C65.8050400@gmail.com>
Date: Fri, 28 Mar 2014 14:43:01 +0100
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Archana kumari <archanakumari959@gmail.com>
Subject: [PATCH] Staging: netlogic: long lines in xlr_net.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch script returns the following warning:
WARNING: line over 80 characters
310: FILE: drivers/staging/netlogic/xlr_net.c:310:
+               void *accel_priv, select_queue_fallback_t fallback)

This patch fixes the coding style issue.

Signed-off-by: Neil Armstrong <superna9999@gmail.com>
---
 drivers/staging/netlogic/xlr_net.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index 31b269a..5e7d271 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -306,8 +306,9 @@ static netdev_tx_t xlr_net_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static u16 xlr_net_select_queue(struct net_device *ndev, struct sk_buff *skb,
-				void *accel_priv, select_queue_fallback_t fallback)
+static u16 xlr_net_select_queue(struct net_device *ndev,
+				struct sk_buff *skb, void *accel_priv,
+				select_queue_fallback_t fallback)
 {
 	return (u16)smp_processor_id();
 }
-- 
1.7.0.4
