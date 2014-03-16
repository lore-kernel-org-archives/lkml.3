Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaCPTMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 15:12:44 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35299 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbaCPTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 15:12:40 -0400
Date: Mon, 17 Mar 2014 08:12:32 +1300
From: Daniel Ngu <daniel.dy.ngu@gmail.com>
To: Jonathan Kim <jonathankim@gctsemi.com>
Cc: Dean ahn <deanahn@gctsemi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: gdm724x: netlink_k.c: fixed coding style
Message-ID: <20140316191232.GA3478@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line over 80 characters

Signed-off-by: Daniel Ngu <daniel.dy.ngu@gmail.com>
---
 drivers/staging/gdm724x/netlink_k.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/gdm724x/netlink_k.c b/drivers/staging/gdm724x/netlink_k.c
index 77fc64e..5ddd369 100644
--- a/drivers/staging/gdm724x/netlink_k.c
+++ b/drivers/staging/gdm724x/netlink_k.c
@@ -32,7 +32,8 @@ static struct semaphore netlink_mutex;
 #define ND_MAX_GROUP		30
 #define ND_IFINDEX_LEN		sizeof(int)
 #define ND_NLMSG_SPACE(len)	(NLMSG_SPACE(len) + ND_IFINDEX_LEN)
-#define ND_NLMSG_DATA(nlh)	((void *)((char *)NLMSG_DATA(nlh) + ND_IFINDEX_LEN))
+#define ND_NLMSG_DATA(nlh)	((void *)((char *)NLMSG_DATA(nlh) + \
+						  ND_IFINDEX_LEN))
 #define ND_NLMSG_S_LEN(len)	(len+ND_IFINDEX_LEN)
 #define ND_NLMSG_R_LEN(nlh)	(nlh->nlmsg_len-ND_IFINDEX_LEN)
 #define ND_NLMSG_IFIDX(nlh)	NLMSG_DATA(nlh)
-- 
1.7.9.5

