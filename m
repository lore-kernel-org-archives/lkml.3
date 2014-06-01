Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaFASyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 14:54:45 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:34747 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaFASyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 14:54:44 -0400
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 14:54:44 EDT
X-SENDER-IP: [85.228.21.18]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap25AGVui1NV5BUSPGdsb2JhbABYgwYBAYRQg3ymUI0Th0yBCRcDAQEBATg1gwIGBBkmXAIWCi2ILQEDFQGzKYQVl00KGScNZIU3jDyBMmQdhCoEmAiBeI06iS07gTA
X-IPAS-Result: Ap25AGVui1NV5BUSPGdsb2JhbABYgwYBAYRQg3ymUI0Th0yBCRcDAQEBATg1gwIGBBkmXAIWCi2ILQEDFQGzKYQVl00KGScNZIU3jDyBMmQdhCoEmAiBeI06iS07gTA
X-IronPort-AV: E=Sophos;i="4.98,952,1392159600"; 
   d="scan'208";a="591778016"
From: Josep Puigdemont <josep.puigdemont@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Josep Puigdemont <josep.puigdemont@gmail.com>
Subject: [PATCH] staging: lustre: Fix coding style
Date: Sun,  1 Jun 2014 20:23:16 +0200
Message-Id: <1401646996-5021-1-git-send-email-josep.puigdemont@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if block should be placed in a new line rather
than after the if statement.
Blank line required between variable declarations and code.

Signed-off-by: Josep Puigdemont <josep.puigdemont@gmail.com>
---
ID: 31f7......b1

 drivers/staging/lustre/lustre/llite/llite_nfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_nfs.c b/drivers/staging/lustre/lustre/llite/llite_nfs.c
index e0e112b..a614b91 100644
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -51,7 +51,9 @@ __u32 get_uuid2int(const char *name, int len)
 	__u32 key0 = 0x12a3fe2d, key1 = 0x37abe8f9;
 	while (len--) {
 		__u32 key = key1 + (key0 ^ (*name++ * 7152373));
-		if (key & 0x80000000) key -= 0x7fffffff;
+
+		if (key & 0x80000000)
+			key -= 0x7fffffff;
 		key1 = key0;
 		key0 = key;
 	}
-- 
1.9.3

