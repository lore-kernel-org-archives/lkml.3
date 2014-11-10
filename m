Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaKJPTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:19:31 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:53590 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaKJPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:19:30 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Robert Richter <rric@kernel.org>
Cc: Chris Rorvick <chris@rorvick.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] oprofile: Fix grammar in Kconfig help.
Date: Mon, 10 Nov 2014 09:19:11 -0600
Message-Id: <1415632751-4312-1-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"user" does not start with a vowel sound, thus "a user" is correct.

  https://owl.english.purdue.edu/owl/resource/591/01/

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 arch/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 97ff872..c566511 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -23,7 +23,7 @@ config OPROFILE_EVENT_MULTIPLEX
 	  The number of hardware counters is limited. The multiplexing
 	  feature enables OProfile to gather more events than counters
 	  are provided by the hardware. This is realized by switching
-	  between events at an user specified time interval.
+	  between events at a user specified time interval.
 
 	  If unsure, say N.
 
-- 
1.9.3

