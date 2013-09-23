Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3IWHga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:36:30 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55749 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3IWHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:36:29 -0400
Message-ID: <523FEF77.4020709@linux.vnet.ibm.com>
Date: Mon, 23 Sep 2013 09:36:23 +0200
From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] documentation: Add links to TRACE_EVENT documentation
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092307-5024-0000-0000-0000074BF4CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

documentation: Add links to TRACE_EVENT documentation

Existing tracepoint documentation doesn't mention the popular
TRACE_EVENT
macro. Since an excellent series of articles on proper usage already
exists, respective links are added to the existing documentation.

Signed-off-by: Stefan Raspl <raspl@linux.vnet.ibm.com>

---
 Documentation/trace/tracepoints.txt |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -99,3 +99,8 @@ core kernel image or in modules.
 If the tracepoint has to be used in kernel modules, an
 EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
 used to export the defined tracepoints.
+
+Note: The convenience macro TRACE_EVENT provides an alternative way to
+      define tracepoints. Check http://lwn.net/Articles/379903,
+      http://lwn.net/Articles/381064 and http://lwn.net/Articles/383362
+      for a series of articles with more details.

