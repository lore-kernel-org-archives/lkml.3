Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaLOGNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:13:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58793 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLOGN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:13:29 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk
Cc: computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 4/4] Documentation: Provide suggestions on when to repost patches
Date: Sun, 14 Dec 2014 22:09:50 -0800
Message-Id: <1418623790-28429-5-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give submitters a rough idea of how long to wait before reposting, to
help avoid situations where a series is reposted before the original
submission is fully reviewed.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 Documentation/development-process/6.Followthrough | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/development-process/6.Followthrough b/Documentation/development-process/6.Followthrough
index 41d324a..6cefb6c 100644
--- a/Documentation/development-process/6.Followthrough
+++ b/Documentation/development-process/6.Followthrough
@@ -74,7 +74,10 @@ around.
 One fatal mistake is to ignore review comments in the hope that they will
 go away.  They will not go away.  If you repost code without having
 responded to the comments you got the time before, you're likely to find
-that your patches go nowhere.
+that your patches go nowhere.  On the flipside, reposting an updated patch
+before the original has been fully reviewed can be a source of frustration
+too, so consider giving the reviewers ~3-7 calendar days (depending on
+patch complexity) before posting V2.
 
 Speaking of reposting code: please bear in mind that reviewers are not
 going to remember all the details of the code you posted the last time
-- 
2.1.1

