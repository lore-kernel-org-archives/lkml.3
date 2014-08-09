Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaHIUaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 16:30:25 -0400
Received: from jambon.ath.cx ([212.129.4.85]:50640 "EHLO debian"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751328AbaHIUaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 16:30:23 -0400
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2014 16:30:22 EDT
From: Junien Fridrick <linux.kernel@junien.fridrick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Siyao <lai.siyao@intel.com>, Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Junien Fridrick <linux.kernel@junien.fridrick.net>
Subject: [PATCH] [next-20140808] [staging] [lustre] Fix coding style in llite/remote_perm.c
Date: Sat,  9 Aug 2014 20:22:48 +0000
Message-Id: <1407615768-6757-1-git-send-email-linux.kernel@junien.fridrick.net>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the noise, this is part of task 10 of the Eudyptula Challenge.

Signed-off-by: Junien Fridrick <linux.kernel@junien.fridrick.net>
---
 drivers/staging/lustre/lustre/llite/remote_perm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/remote_perm.c b/drivers/staging/lustre/lustre/llite/remote_perm.c
index f61fefc..3a9c8e8 100644
--- a/drivers/staging/lustre/lustre/llite/remote_perm.c
+++ b/drivers/staging/lustre/lustre/llite/remote_perm.c
@@ -100,7 +100,7 @@ void free_rmtperm_hash(struct hlist_head *hash)
 	struct ll_remote_perm *lrp;
 	struct hlist_node *next;
 
-	if(!hash)
+	if (!hash)
 		return;
 
 	for (i = 0; i < REMOTE_PERM_HASHSIZE; i++)
-- 
2.0.1

