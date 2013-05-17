Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3EQU17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 16:27:59 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:40252 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab3EQU15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 16:27:57 -0400
From: Rabin Vincent <rabin@rab.in>
To: acme@redhat.com, mingo@kernel.org
Cc: bp@suse.de, linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH] tools lib lk: respect CROSS_COMPILE
Date: Fri, 17 May 2013 22:27:44 +0200
Message-Id: <1368822464-4887-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make lk use CROSS_COMPILE, in order to be able to cross compile perf
again.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 tools/lib/lk/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 926cbf3..2c5a197 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -1,5 +1,8 @@
 include ../../scripts/Makefile.include
 
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
-- 
1.8.1.2

