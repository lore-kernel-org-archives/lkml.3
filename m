Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaCaPn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:43:56 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51256 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaCaPnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:43:49 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: netdev@vger.kernel.org, pablo@netfilter.org, kaber@trash.net,
        kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 4/5] netfilter: Fix format string mismatch in nf_conntrack_irc_init()
Date: Tue,  1 Apr 2014 00:43:38 +0900
Message-Id: <1396280619-31152-3-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.9.1.352.gd393d14
In-Reply-To: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
References: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in nf_conntrack_irc_init()

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/netfilter/nf_conntrack_irc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 0fd2976..8ee3a5f 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -263,7 +263,7 @@ static int __init nf_conntrack_irc_init(void)
 		if (ports[i] == IRC_PORT)
 			sprintf(irc[i].name, "irc");
 		else
-			sprintf(irc[i].name, "irc-%u", i);
+			sprintf(irc[i].name, "irc-%d", i);
 
 		ret = nf_conntrack_helper_register(&irc[i]);
 		if (ret) {
-- 
1.9.1.352.gd393d14

