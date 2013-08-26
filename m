Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab3HZPLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48645 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3HZPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:52 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/24] Staging: winbond: wb35rx: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:18 +0200
Message-Id: <1377529823-5116-20-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some lines over 80 characters.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/wb35rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index 48ed95c..999b7046 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -16,7 +16,8 @@
 #include "core.h"
 #include "wb35rx_f.h"
 
-static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
+static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress,
+				int PacketSize)
 {
 	struct wbsoft_priv *priv = hw->priv;
 	struct sk_buff *skb;
@@ -306,7 +307,9 @@ static void Wb35Rx_reset_descriptor(struct hw_data *pHwData)
 	pWb35Rx->EP3vm_state = VM_STOP;
 	pWb35Rx->rx_halt = 0;
 
-	/* Initial the Queue. The last buffer is reserved for used if the Rx resource is unavailable. */
+	/* Initial the Queue. The last buffer is reserved for used if the Rx
+	 * resource is unavailable.
+	*/
 	for (i = 0; i < MAX_USB_RX_BUFFER_NUMBER; i++)
 		pWb35Rx->RxOwner[i] = 1;
 }
-- 
1.8.1.2

