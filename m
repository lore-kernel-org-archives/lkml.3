Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3LCRIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:08:49 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61114 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754400Ab3LCRIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:08:34 -0500
Message-Id: <20131203170833.411600272@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 03 Dec 2013 12:07:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [for-next][PATCH 2/2] ktest: Add documentation of CLOSE_CONSOLE_SIGNAL
References: <20131203170722.102711563@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Add-documentation-of-CLOSE_CONSOLE_SIGNAL.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The sample.conf file needs to document all available options.
With the new CLOSE_CONSOE_SIGNAL option, it too needs to be
document.

Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/sample.conf | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 0a290fb..2eb4bd2 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -328,6 +328,13 @@
 # For a virtual machine with guest name "Guest".
 #CONSOLE =  virsh console Guest
 
+# Signal to send to kill console.
+# ktest.pl will create a child process to monitor the console.
+# When the console is finished, ktest will kill the child process
+# with this signal.
+# (default INT)
+#CLOSE_CONSOLE_SIGNAL = HUP
+
 # Required version ending to differentiate the test
 # from other linux builds on the system.
 #LOCALVERSION = -test
-- 
1.8.4.rc3


