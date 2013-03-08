Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3CHLdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:33:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3CHLdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:33:40 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=32Sf7oGPjPMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=U3iPmR7jdqcA:10 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=BYFiSKukPt_gyS9tDhQA:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362742418.31874.89.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][3.9] tracing: update documentation of snapshot
 utility
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "yrl.pp-manager.tt" <yrl.pp-manager.tt@hitachi.com>
Date: Fri, 08 Mar 2013 06:33:38 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is based on top of my last pull request for tip/perf/urgent.

Thanks,

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: 1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3


Hiraku Toyooka (1):
      tracing: update documentation of snapshot utility

----
 Documentation/trace/ftrace.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---------------------------
commit 1abccd7419de9829bcdf9ab1f81d5f6cf74d55d3
Author: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Date:   Fri Mar 8 16:32:25 2013 +0900

    tracing: update documentation of snapshot utility
    
    Now, "snapshot" file returns success on a reset of snapshot buffer
    even if the buffer wasn't allocated, instead of returning EINVAL.
    This patch updates snapshot desctiption according to the change.
    
    Link: http://lkml.kernel.org/r/51399409.4090207@hitachi.com
    
    Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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


