Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaLOGNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:13:46 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49842 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaLOGN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:13:27 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk
Cc: computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 3/4] Documentation: Add cutoff periods for patch acceptance
Date: Sun, 14 Dec 2014 22:09:49 -0800
Message-Id: <1418623790-28429-4-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been a recurring source of confusion for the new submitters who
I've helped; let's see if adding a small illustration improves the
situation.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/development-process/5.Posting | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index 14f8b01..50cf4dc 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -35,6 +35,22 @@ merge window has closed.  You can visit https://www.kernel.org/ to check
 the merge window status; it is closed if the "mainline:" entry shows a
 version number containing "-rc", and open if a non-rc version number appears.
 
+In many cases, feature additions received and accepted somewhere in the range
+of [N-rc1, N-rc5) will be merged into the -next tree targeting the (N+1) Linux
+release.  For example:
+
+  kernel.org "mainline:"  |  Patch may appear
+  field when posted       |  in released kernel
+  ------------------------+--------------------------------
+  3.18-rc[1-4]            |  3.19
+  3.18-rc[5-9]            |  3.20
+  3.18                    |  Merge window open - don't post
+  3.19-rc[1-4]            |  3.20
+  3.19-rc[5-9]            |  3.21
+  3.19                    |  Merge window open - don't post
+
+Bug fixes can typically be accepted at any time.
+
 
 5.2: BEFORE CREATING PATCHES
 
-- 
2.1.1

