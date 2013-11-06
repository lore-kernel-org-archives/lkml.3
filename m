Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab3KFWVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:21:14 -0500
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:42553 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3KFWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:21:13 -0500
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH] perf: Remove unneeded include
Date: Wed,  6 Nov 2013 22:20:54 +0000
Message-Id: <1383776454-10595-1-git-send-email-rodrigo@sdfg.com.ar>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in sort.h including itself.

The include was added when the file was created, in commit "perf tools: Create
util/sort.and use it" (dd68ada2d) and added a include to "sort.h" in lot of
files (all the files that started using the file). It was probably added by
mistake on sort.h too.

Signed-off-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
---
 tools/perf/util/sort.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f4cc147..43e5ff4 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -22,7 +22,6 @@
 #include "parse-events.h"
 
 #include "thread.h"
-#include "sort.h"
 
 extern regex_t parent_regex;
 extern const char *sort_order;
-- 
1.8.4.rc3

