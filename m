Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaLOGNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:13:37 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36680 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaLOGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:13:26 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk
Cc: computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/4] Documentation/SubmitChecklist: Remind submitters to check the merge window
Date: Sun, 14 Dec 2014 22:09:48 -0800
Message-Id: <1418623790-28429-3-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the checklist does not provide an indication of appropriate
times to send patches; add a brief note on the topic.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/SubmitChecklist | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/SubmitChecklist b/Documentation/SubmitChecklist
index 2b7e32d..8b23f9c 100644
--- a/Documentation/SubmitChecklist
+++ b/Documentation/SubmitChecklist
@@ -107,3 +107,8 @@ kernel patches.
     CONFIG_SMP, CONFIG_SYSFS, CONFIG_PROC_FS, CONFIG_INPUT, CONFIG_PCI,
     CONFIG_BLOCK, CONFIG_PM, CONFIG_MAGIC_SYSRQ,
     CONFIG_NET, CONFIG_INET=n (but latter with CONFIG_NET=y)
+
+27: For patches which are not urgent fixes for bugs in the current tree,
+    double-check https://www.kernel.org/ to make sure the merge window is
+    CLOSED ("mainline:" showing an -rc kernel) before sending.  For more
+    information on the release cycle, see Documentation/development-process/.
-- 
2.1.1

