Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3AXUgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:36:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50137 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3AXUIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jon Stanley <jonstanley@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/74] tools lib traceevent: Add copyright header
Date: Thu, 24 Jan 2013 17:07:43 -0300
Message-Id: <1359058103-31645-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Stanley <jonstanley@gmail.com>

Adding a missing copyright header to parse-utils.c. Assuminng that the
license is LGPL like the rest of the trace-cmd library code.

Signed-off-by: Jon Stanley <jonstanley@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347127251-4695-1-git-send-email-jonstanley@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-utils.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/lib/traceevent/parse-utils.c b/tools/lib/traceevent/parse-utils.c
index f023a13..bba701c 100644
--- a/tools/lib/traceevent/parse-utils.c
+++ b/tools/lib/traceevent/parse-utils.c
@@ -1,3 +1,22 @@
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
1.8.1.1.361.gec3ae6e

