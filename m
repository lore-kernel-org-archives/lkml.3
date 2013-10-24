Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3JXTP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:15:26 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53141 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab3JXTOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:47 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 4/5] Documentation: Add kernelshark.1.txt
Date: Thu, 24 Oct 2013 14:14:33 -0500
Message-Id: <1382642074-15567-5-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a man page for kernelshark.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Documentation/kernelshark.1.txt | 46 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/kernelshark.1.txt

diff --git a/Documentation/kernelshark.1.txt b/Documentation/kernelshark.1.txt
new file mode 100644
index 0000000..6a217dd
--- /dev/null
+++ b/Documentation/kernelshark.1.txt
@@ -0,0 +1,46 @@
+KERNELSHARK(1)
+==============
+
+NAME
+----
+kernelshark - graphical reader for trace-cmd(1) output
+
+SYNOPSIS
+--------
+*kernelshark* ['OPTIONS']
+
+DESCRIPTION
+-----------
+KernelShark is a front end reader of trace-cmd(1) output. It reads a 
+trace-cmd.dat(5) formatted file and produces a graph and list view of the
+data.
+
+OPTIONS
+-------
+*-h*::
+    Display the help text.
+
+*-v*::
+    Display the kernelshark version and exit.
+
+*-i* 'input-file'::
+    Read trace data from the file 'input-file'. By default input is read from
+    'trace.dat'.
+
+SEE ALSO
+--------
+trace-cmd(1)
+
+AUTHOR
+------
+Written by Steven Rostedt, <rostedt@goodmis.org>
+
+RESOURCES
+---------
+git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
+
+COPYING
+-------
+Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
+the terms of the GNU Public License (GPL).
+
-- 
1.8.3.2

