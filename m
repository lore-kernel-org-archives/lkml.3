Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaIYDNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:13:49 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36185 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaIYDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:13:48 -0400
Date: Wed, 24 Sep 2014 23:13:45 -0400
From: Elshad Mustafayev <elshadimo@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel: acctc.c: Fixed else if not generally userful after a
 break or return warning.
Message-ID: <20140925031345.GA5252@emustafa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Elshad Mustafayev <elshadimo@gmail.com>
---
 kernel/acct.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index b4c667d..ed4cf00 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -376,9 +376,8 @@ static comp2_t encode_comp2_t(u64 value)
 	if (exp > MAXEXP2) {
 		/* Overflow. Return largest representable number instead. */
 		return (1ul << (MANTSIZE2+EXPSIZE2-1)) - 1;
-	} else {
-		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
 	}
+	return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
 }
 #endif
 
-- 
1.9.1

