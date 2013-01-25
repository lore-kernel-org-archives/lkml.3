Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3AYL2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:28:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:28:32 -0500
Date: Fri, 25 Jan 2013 03:28:13 -0800
From: tip-bot for Jon Stanley <jonstanley@gmail.com>
Message-ID: <tip-2d2481ddf634695aa17ad91bd765572329941674@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, jonstanley@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jonstanley@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1347127251-4695-1-git-send-email-jonstanley@gmail.com>
References: <1347127251-4695-1-git-send-email-jonstanley@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Add copyright header
Git-Commit-ID: 2d2481ddf634695aa17ad91bd765572329941674
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:28:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d2481ddf634695aa17ad91bd765572329941674
Gitweb:     http://git.kernel.org/tip/2d2481ddf634695aa17ad91bd765572329941674
Author:     Jon Stanley <jonstanley@gmail.com>
AuthorDate: Sat, 8 Sep 2012 14:00:51 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:17 -0300

tools lib traceevent: Add copyright header

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
