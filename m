Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3JFKu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 06:50:57 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41090 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3JFKuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 06:50:55 -0400
Date: Sun, 6 Oct 2013 18:50:42 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: trivial@kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH TRIVIAL] cleanup: add spaces around bitwise operator
Message-ID: <20131006105042.GA2898@will>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2a0e21d..bc04f15 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2658,7 +2658,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (kind != 2 && !ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if (kind == 2 && nlh->nlmsg_flags&NLM_F_DUMP) {
+	if (kind == 2 && nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct sock *rtnl;
 		rtnl_dumpit_func dumpit;
 		rtnl_calcit_func calcit;
-- 
1.8.3.1

