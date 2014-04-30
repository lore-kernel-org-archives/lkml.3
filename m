Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422780AbaD3OcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52338 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759223AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: [RFC 06/16] kgr: add Documentation
Date: Wed, 30 Apr 2014 16:30:39 +0200
Message-Id: <1398868249-26169-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a text provided by Udo and polished.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Udo Seidel <udoseidel@gmx.de>
---
 Documentation/kgr.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/kgr.txt

diff --git a/Documentation/kgr.txt b/Documentation/kgr.txt
new file mode 100644
index 000000000000..5b62415641cf
--- /dev/null
+++ b/Documentation/kgr.txt
@@ -0,0 +1,26 @@
+Live Kernel Patching with kGraft
+--------------------------------
+
+Written by Udo Seidel <udoseidel at gmx dot de>
+Based on the Blog entry by Vojtech Pavlik
+
+April 2014
+
+kGraft's developement was started by the SUSE Labs. kGraft builds on
+technologies and ideas that are already present in the kernel: ftrace
+and its mcount-based reserved space in function headers, the
+INT3/IPI-NMI patching also used in jumplabels, and RCU-like update of
+code that does not require stopping the kernel. For more information
+about ftrace please checkout the Documentation shipped with the kernel
+or search for howtos and explanations on the Internet.
+
+A kGraft patch is a kernel module and fully relies on the in-kernel
+module loader to link the new code with the kernel.  Thanks to all
+that, the design can be nicely minimalistic.
+
+While kGraft is, by choice, limited to replacing whole functions and
+constants they reference, this does not limit the set of code patches
+that can be applied significantly.  kGraft offers tools to assist in
+creating the live patch modules, identifying which functions need to
+be replaced based on a patch, and creating the patch module source
+code. They are located in /tools/kgraft/.
-- 
1.9.2

