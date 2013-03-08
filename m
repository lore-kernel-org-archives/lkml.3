Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297Ab3CHPGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:06:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3CHPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:06:52 -0500
Date: Fri, 8 Mar 2013 07:05:29 -0800
From: tip-bot for Hiraku Toyooka <tipbot@zytor.com>
Message-ID: <tip-1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, hiraku.toyooka.gu@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hiraku.toyooka.gu@hitachi.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <51399409.4090207@hitachi.com>
References: <51399409.4090207@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing:
  update documentation of snapshot utility
Git-Commit-ID: 1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Mar 2013 07:05:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3
Gitweb:     http://git.kernel.org/tip/1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3
Author:     Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
AuthorDate: Fri, 8 Mar 2013 16:32:25 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 8 Mar 2013 06:27:11 -0500

tracing: update documentation of snapshot utility

Now, "snapshot" file returns success on a reset of snapshot buffer
even if the buffer wasn't allocated, instead of returning EINVAL.
This patch updates snapshot desctiption according to the change.

Link: http://lkml.kernel.org/r/51399409.4090207@hitachi.com

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 53d6a3c..a372304 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1873,7 +1873,7 @@ feature:
 
 	status\input  |     0      |     1      |    else    |
 	--------------+------------+------------+------------+
-	not allocated |(do nothing)| alloc+swap |   EINVAL   |
+	not allocated |(do nothing)| alloc+swap |(do nothing)|
 	--------------+------------+------------+------------+
 	allocated     |    free    |    swap    |   clear    |
 	--------------+------------+------------+------------+
