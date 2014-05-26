Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaEZWRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:17:30 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44466 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaEZWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:17:24 -0400
Date: Mon, 26 May 2014 23:17:18 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, richard@nod.at
Subject: [PATCH 12/12] [include/linux] Remove strict_strto definitions
Message-ID: <20140526221718.GN25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 12/12] [include/linux] remove strict_strto* definitions

Remove obsolete and unused strict_strto* functions

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 include/linux/kernel.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4c52907..a39043c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -376,10 +376,6 @@ extern unsigned long simple_strtoul(const char *,char **,unsigned int);
 extern long simple_strtol(const char *,char **,unsigned int);
 extern unsigned long long simple_strtoull(const char *,char **,unsigned int);
 extern long long simple_strtoll(const char *,char **,unsigned int);
-#define strict_strtoul	kstrtoul
-#define strict_strtol	kstrtol
-#define strict_strtoull	kstrtoull
-#define strict_strtoll	kstrtoll
 
 extern int num_to_str(char *buf, int size, unsigned long long num);
 
-- 
1.9.3

