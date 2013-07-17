Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3GQTTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:19:10 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:65013 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3GQTTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:19:08 -0400
From: enselic@gmail.com
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        Martin Nordholts <enselic@gmail.com>
Subject: [PATCH] Documentation: development-process: Update -mm and -next URLs
Date: Wed, 17 Jul 2013 21:19:06 +0200
Message-Id: <1374088746-6862-1-git-send-email-enselic@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Nordholts <enselic@gmail.com>

Both old URLs are broken, so update them.

Signed-off-by: Martin Nordholts <enselic@gmail.com>
---
 Documentation/development-process/2.Process |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/development-process/2.Process b/Documentation/development-process/2.Process
index 4823577..2e06179 100644
--- a/Documentation/development-process/2.Process
+++ b/Documentation/development-process/2.Process
@@ -276,7 +276,7 @@ mainline get there via -mm.
 The current -mm patch is available in the "mmotm" (-mm of the moment)
 directory at:
 
-	http://userweb.kernel.org/~akpm/mmotm/
+	http://www.ozlabs.org/~akpm/mmotm/
 
 Use of the MMOTM tree is likely to be a frustrating experience, though;
 there is a definite chance that it will not even compile.
@@ -287,7 +287,7 @@ the mainline is expected to look like after the next merge window closes.
 Linux-next trees are announced on the linux-kernel and linux-next mailing
 lists when they are assembled; they can be downloaded from:
 
-	http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/
+	http://www.kernel.org/pub/linux/kernel/next/
 
 Some information about linux-next has been gathered at:
 
-- 
1.7.10.4

