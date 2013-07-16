Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030Ab3GPUlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:41:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59149 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993Ab3GPUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:18 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/6] Documentation/kconfig: more concise and straightforward search explanation
Date: Tue, 16 Jul 2013 22:39:57 +0200
Message-Id: <9e554dd7b2de269c697943712d91b668f27a42bd.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Re-phrase the explanations on the sorting of search results, in a more
concise and complete way.

Drop reference to the user's locale when sorting alphabetically, since
this is implicit.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 Documentation/kbuild/kconfig.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index e9f9e76..d58a2ea 100644
--- a/Documentation/kbuild/kconfig.txt
+++ b/Documentation/kbuild/kconfig.txt
@@ -175,11 +175,9 @@ Searching in menuconfig:
 		/^hotplug
 
 	When searching, symbols are sorted thus:
-	  - exact match first: an exact match is when the search matches
-	    the complete symbol name;
-	  - alphabetical order: when two symbols do not match exactly,
-	    they are sorted in alphabetical order (in the user's current
-	    locale).
+	  - first, exact matches, sorted alphabetically (an exact match
+	    is when the search matches the complete symbol name);
+	  - then, other matches, sorted alphabetically.
 	For example: ^ATH.K matches:
 	    ATH5K ATH9K ATH5K_AHB ATH5K_DEBUG [...] ATH6KL ATH6KL_DEBUG
 	    [...] ATH9K_AHB ATH9K_BTCOEX_SUPPORT ATH9K_COMMON [...]
-- 
1.8.1.2

