Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3JVWb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:31:28 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:39442 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755835Ab3JVWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:31:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1538:1567:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3865:3868:3871:4321:5007:6261:10004:10026:10848:11658:11914:12296:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: straw60_b7df720f9535
X-Filterd-Recvd-Size: 1294
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, keyrings@linux-nfs.org
Subject: [PATCH 20/24] key: Convert use of typedef ctl_table to struct ctl_table
Date: Tue, 22 Oct 2013 15:30:03 -0700
Message-Id: <c565747ed0be7fc8fdcec6677b5f4edca3a6fece.1382480758.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382480758.git.joe@perches.com>
References: <cover.1382480758.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/key.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index 4dfde11..3b98ce0 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -310,7 +310,7 @@ do {									\
 } while (0)
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern struct ctl_table key_sysctls[];
 #endif
 /*
  * the userspace interface
-- 
1.8.1.2.459.gbcd45b4.dirty

