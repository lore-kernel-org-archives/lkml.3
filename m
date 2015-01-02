Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbbABDDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 22:03:34 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36652 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbbABDDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 22:03:32 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: corbet@lwn.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-mm@kvack.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: mm: Fix typo in vm.txt
Date: Fri,  2 Jan 2015 12:03:19 +0900
Message-Id: <1420167799-9587-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.2.1.62.g3f15098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a spelling typo in Documentation/sysctl/vm.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sysctl/vm.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 4415aa9..de3afef 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -728,7 +728,7 @@ The default value is 60.
 
 - user_reserve_kbytes
 
-When overcommit_memory is set to 2, "never overommit" mode, reserve
+When overcommit_memory is set to 2, "never overcommit" mode, reserve
 min(3% of current process size, user_reserve_kbytes) of free memory.
 This is intended to prevent a user from starting a single memory hogging
 process, such that they cannot recover (kill the hog).
-- 
2.2.1.62.g3f15098

