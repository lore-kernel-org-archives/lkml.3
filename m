Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaKQVEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:04:11 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:29244 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbaKQVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:04:09 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYNAKVhalRXQyyZ/2dsb2JhbABbgw6BLrhwBQF1mhWBGxcBAQEBAX2EXyOBGjeIRQHCUpBJhj6KZB2ENQWeTJZ6gUcBgjU8MIJLAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] net: fix spelling for synchronized
Date: Mon, 17 Nov 2014 22:04:03 +0100
Message-Id: <1416258243-7685-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/core/dev_addr_lists.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index b6b2306..c0548d2 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -278,8 +278,8 @@ int __hw_addr_sync_dev(struct netdev_hw_addr_list *list,
 EXPORT_SYMBOL(__hw_addr_sync_dev);
 
 /**
- *  __hw_addr_unsync_dev - Remove synchonized addresses from device
- *  @list: address list to remove syncronized addresses from
+ *  __hw_addr_unsync_dev - Remove synchronized addresses from device
+ *  @list: address list to remove synchronized addresses from
  *  @dev:  device to sync
  *  @unsync: function to call if address should be removed
  *
-- 
1.9.3

