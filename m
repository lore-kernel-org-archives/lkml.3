Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3ALWjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 17:39:53 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:37876 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab3ALWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 17:39:52 -0500
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] linux-firmware: add MISSING file
Date: Sat, 12 Jan 2013 23:39:43 +0100
Message-Id: <1358030383-15609-1-git-send-email-xose.vazquez@gmail.com>
X-Mailer: git-send-email 1.7.11.7
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to document the reason why a firmware is not present

Cc: Daniel Drake <dsd@laptop.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 MISSING | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 MISSING

diff --git a/MISSING b/MISSING
new file mode 100644
index 0000000..f228099
--- /dev/null
+++ b/MISSING
@@ -0,0 +1,20 @@
+             ***********
+             * MISSING *
+             ***********
+
+This file attempts to document the reason why a firmware is not present
+in this bundle.
+
+--------------------------------------------------------------------------
+
+Driver: zd1211rw -- ZyDAS/Atheros ZD1211/ZD1211B/AR5007UG wireless driver
+
+Trouble: Allegedly GPLv2, but no source visible. Found in hex form in the
+         vendor driver.
+
+URL: http://sf.net/projects/zd1211/files/
+
+Implication: CRITICAL, hardware undetected.
+
+--------------------------------------------------------------------------
+
-- 
1.7.11.7

