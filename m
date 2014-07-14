Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbaGNQdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:33:13 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:27168 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756149AbaGNQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:32:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgNACUFxFNXQxRI/2dsb2JhbABZgw6tSQEBAQEBAQUBbpt/AYEVF3WEBAEFJy8jEFE5HhmIRgHIMReFe4lQBxaELQEEmw6LV4hHg0Y7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Subject: [PATCH 07/16] drop_monitor: remove unnecessary break after return
Date: Mon, 14 Jul 2014 18:30:57 +0200
Message-Id: <1405355467-7350-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1405355467-7350-1-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/drop_monitor.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index e70301e..50f9a9d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -289,10 +289,8 @@ static int net_dm_cmd_trace(struct sk_buff *skb,
 	switch (info->genlhdr->cmd) {
 	case NET_DM_CMD_START:
 		return set_all_monitor_traces(TRACE_ON);
-		break;
 	case NET_DM_CMD_STOP:
 		return set_all_monitor_traces(TRACE_OFF);
-		break;
 	}
 
 	return -ENOTSUPP;
-- 
1.8.4.5

