Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3LLO1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:27:21 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:43602 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3LLO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:27:20 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] Documentation: fix spelling in design-patterns
Date: Thu, 12 Dec 2013 15:27:12 +0100
Message-Id: <1386858432-5457-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes two spelling mistakes in the design pattern doc.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/driver-model/design-patterns.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-model/design-patterns.txt b/Documentation/driver-model/design-patterns.txt
index 9ef8c1684558..ba7b2df64904 100644
--- a/Documentation/driver-model/design-patterns.txt
+++ b/Documentation/driver-model/design-patterns.txt
@@ -66,7 +66,7 @@ your interrupt handler.
 2. container_of()
 ~~~~~~~~~~~~~~~~~
 
-Continuing on the above example we add a offloaded work:
+Continuing on the above example we add an offloaded work:
 
 struct foo {
     spinlock_t lock;
@@ -99,7 +99,7 @@ static int foo_probe(...)
     (...)
 }
 
-The design pattern is the same for a a hrtimer or something similar that will
+The design pattern is the same for an hrtimer or something similar that will
 return a single argument which is a pointer to a struct member in the
 callback.
 
-- 
1.8.3.1

