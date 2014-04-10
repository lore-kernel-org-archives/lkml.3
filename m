Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbaDJSyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:54:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:41393 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbaDJSyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:54:31 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, jack@suse.cz
Subject: [PATCH 12/15] kernel:acctc: not function
Date: Thu, 10 Apr 2014 19:54:28 +0100
Message-Id: <1397156068-6883-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: return is not a function, parentheses are not required

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 kernel/acct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 3fdafa9..808a86f 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -262,7 +262,7 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 	if (name) {
 		struct filename *tmp = getname(name);
 		if (IS_ERR(tmp))
-			return (PTR_ERR(tmp));
+			return PTR_ERR(tmp);
 		error = acct_on(tmp);
 		putname(tmp);
 	} else {
-- 
1.8.3.2

