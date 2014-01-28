Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaA1QFk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:05:40 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44378 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaA1QFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:05:37 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] net: Fix warning on make htmldocs caused by skbuff.c
Date: Wed, 29 Jan 2014 01:05:28 +0900
Message-Id: <1390925128-20768-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed following Warning while executing "make htmldocs".

Warning(/net/core/skbuff.c:2164): No description found for parameter 'from'
Warning(/net/core/skbuff.c:2164): Excess function parameter 'source'
description in 'skb_zerocopy'
Replace "@source" with "@from" fixed the warning.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 15057d2..16a7c78 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2149,7 +2149,7 @@ EXPORT_SYMBOL_GPL(skb_zerocopy_headlen);
 /**
  *	skb_zerocopy - Zero copy skb to skb
  *	@to: destination buffer
- *	@source: source buffer
+ *	@from: source buffer
  *	@len: number of bytes to copy from source buffer
  *	@hlen: size of linear headroom in destination buffer
  *
-- 
1.9.rc1

