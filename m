Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaC1Jns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:43:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33506 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaC1Jnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:43:46 -0400
Message-ID: <5335444F.1050208@gmail.com>
Date: Fri, 28 Mar 2014 10:43:43 +0100
From: Neil Armstrong <superna9999@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Archana kumari <archanakumari959@gmail.com>
Subject: [PATCH] Fix coding style issue in xlr_net.c
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
 drivers/staging/netlogic/xlr_net.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c
b/drivers/staging/netlogic/xlr_net.c
index 31b269a..cef0b8a 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -307,7 +307,8 @@ static netdev_tx_t xlr_net_start_xmit(struct sk_buff
*skb,
 }

 static u16 xlr_net_select_queue(struct net_device *ndev, struct sk_buff
*skb,
-				void *accel_priv, select_queue_fallback_t fallback)
+				struct sk_buff *skb, void *accel_priv,
+				select_queue_fallback_t fallback)
 {
 	return (u16)smp_processor_id();
 }
-- 
1.7.0.4
