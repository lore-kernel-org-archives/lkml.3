Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3CTR3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:29:09 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:33367 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3CTR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:29:07 -0400
From: Daniel Baluta <dbaluta@ixiacom.com>
To: davem@davemloft.net
Cc: willemb@google.com, edumazet@google.com, linux-kernel@vger.kernel.org,
        Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] net: fix psock_fanout selftest bind error message
Date: Wed, 20 Mar 2013 19:28:56 +0200
Message-Id: <1363800536-3615-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 .../testing/selftests/net-afpacket/psock_fanout.c  |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/selftests/net-afpacket/psock_fanout.c b/tools/testing/selftests/net-afpacket/psock_fanout.c
index f765f09..226e5e3 100644
--- a/tools/testing/selftests/net-afpacket/psock_fanout.c
+++ b/tools/testing/selftests/net-afpacket/psock_fanout.c
@@ -97,7 +97,7 @@ static void pair_udp_open(int fds[], uint16_t port)
 		exit(1);
 	}
 	if (connect(fds[0], (void *) &daddr, sizeof(daddr))) {
-		perror("bind");
+		perror("connect");
 		exit(1);
 	}
 }
-- 
1.7.5.4

