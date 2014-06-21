Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964946AbaFUMHF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:07:05 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57378 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbaFUMHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:07:02 -0400
Date: Sat, 21 Jun 2014 13:06:58 +0100
From: Daniel Walter <dwalter@google.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 9/9] [include/linux] remove strict_strto* definitions
Message-ID: <20140621120658.GA9253@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
2.0.0.526.g5318336

