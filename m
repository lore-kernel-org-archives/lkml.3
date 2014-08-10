Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaHJXHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 19:07:49 -0400
Received: from jambon.ath.cx ([212.129.4.85]:41444 "EHLO debian"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbaHJXHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 19:07:48 -0400
From: Junien Fridrick <linux.kernel@junien.fridrick.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lai Siyao <lai.siyao@intel.com>, Oleg Drokin <oleg.drokin@intel.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Junien Fridrick <linux.kernel@junien.fridrick.net>
Subject: [PATCH v2] staging: lustre: fix coding style issue: missing space after 'if'
Date: Sun, 10 Aug 2014 23:05:38 +0000
Message-Id: <1407711938-2046-1-git-send-email-linux.kernel@junien.fridrick.net>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140810122411.GF28863@kroah.com>
References: <20140810122411.GF28863@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style issue reported by checkpatch.pl

Signed-off-by: Junien Fridrick <linux.kernel@junien.fridrick.net>
---
This patch is part of task 10 of the eudyptula challenge
Applies to next-20140808

v2 : fixed patch short summary and description

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

