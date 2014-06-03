Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaFCP1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:27:07 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:63600 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaFCP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:27:04 -0400
Date: Tue, 3 Jun 2014 16:27:01 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, rostedt@goodmis.org
Subject: [PATCH v2 11/11] [include/linux] remove strict_strto* definitions
Message-ID: <20140603152701.GM28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 11/11] [include/linux] remove strict_strto* definitions

Remove obsolete and unused strict_strto* functions

Signed-off-by: Daniel Walter <dwalter@google.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
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

