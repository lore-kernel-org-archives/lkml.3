Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaLOGNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:13:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58974 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaLOGNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:13:25 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk
Cc: computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/4] Documentation: Change policy on sending patches during merge window
Date: Sun, 14 Dec 2014 22:09:47 -0800
Message-Id: <1418623790-28429-2-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ask patch submitters to avoid sending non-critical patches when the
merge window is open.  This basically extends the net-next policy in
netdev-FAQ.txt to the entire kernel.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/development-process/5.Posting | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/development-process/5.Posting b/Documentation/development-process/5.Posting
index 8a48c9b..14f8b01 100644
--- a/Documentation/development-process/5.Posting
+++ b/Documentation/development-process/5.Posting
@@ -26,6 +26,15 @@ which remains to be done and any known problems.  Fewer people will look at
 patches which are known to be half-baked, but those who do will come in
 with the idea that they can help you drive the work in the right direction.
 
+Some maintainers prefer to receive only urgent patches when the merge
+window is open, so that critical fixes do not get lost in the noise during
+times of peak activity.  If you are posting an actual [PATCH] (not something
+that is obviously low-priority such as an [RFC] or [RANT]) and you aren't sure
+of your maintainer's stance, the safest thing to do is hold off until the
+merge window has closed.  You can visit https://www.kernel.org/ to check
+the merge window status; it is closed if the "mainline:" entry shows a
+version number containing "-rc", and open if a non-rc version number appears.
+
 
 5.2: BEFORE CREATING PATCHES
 
-- 
2.1.1

