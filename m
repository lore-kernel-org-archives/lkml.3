Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaFDPWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:22:35 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51808 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaFDPWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:22:34 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jiri Kosina <trivial@kernel.org>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH trivial] include/linux/socket.h: Fix comment
Date: Wed,  4 Jun 2014 17:22:18 +0200
Message-Id: <1401895339-28299-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File descriptors are always closed on exit :-)

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/socket.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8e98297..99d2466 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -256,7 +256,7 @@ struct ucred {
 #define MSG_EOF         MSG_FIN
 
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
-#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exit for file
+#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
 					   descriptor received through
 					   SCM_RIGHTS */
 #if defined(CONFIG_COMPAT)
-- 
1.9.2

