Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3IYRUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:20:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54917 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3IYRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:20:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf tools: Explicitly add libdl dependency
Date: Wed, 25 Sep 2013 14:20:26 -0300
Message-Id: <1380129628-16808-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Fixes compile failure on Fedora 12.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1379900700-5186-3-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 346ee92..5f6f9b3 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -87,7 +87,7 @@ CFLAGS += -Wall
 CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
-EXTLIBS = -lelf -lpthread -lrt -lm
+EXTLIBS = -lelf -lpthread -lrt -lm -ldl
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
-- 
1.8.1.4

