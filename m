Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaFTTsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:48:12 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:46476 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaFTTsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:48:10 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] trivial: net/irda/irlmp.c: Fix closing brace followed by if
Date: Fri, 20 Jun 2014 21:48:00 +0200
Message-Id: <1403293680-17568-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 net/irda/irlmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 98ad6ec..a5f28d4 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -1426,7 +1426,8 @@ __u8 *irlmp_hint_to_service(__u8 *hint)
 		if (hint[1] & HINT_TELEPHONY) {
 			IRDA_DEBUG(1, "Telephony ");
 			service[i++] = S_TELEPHONY;
-		} if (hint[1] & HINT_FILE_SERVER)
+		}
+		if (hint[1] & HINT_FILE_SERVER)
 			IRDA_DEBUG(1, "File Server ");
 
 		if (hint[1] & HINT_COMM) {
-- 
1.9.2

