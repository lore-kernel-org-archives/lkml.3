Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3GMSJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:09:04 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57891 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758161Ab3GMSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:08:37 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/3] Documentation/kconfig: more concise and straightforward search explanation
Date: Sat, 13 Jul 2013 20:08:23 +0200
Message-Id: <1373738905-23396-2-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
---
 Documentation/kbuild/kconfig.txt | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/Documentation/kbuild/kconfig.txt b/Documentation/kbuild/kconfig.txt
index e9f9e76..6edf37d 100644
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
+	  - first, exact matches, sorted alphabetically (an exact match                                                                │18:03 -!- - keep a notice in the topic and perhaps as an on-join message).
+	    is when the search matches the complete symbol name);                                                                      │18:03 -!- -  
+	  - then, other matches, sorted alphabetically.
 	For example: ^ATH.K matches:
 	    ATH5K ATH9K ATH5K_AHB ATH5K_DEBUG [...] ATH6KL ATH6KL_DEBUG
 	    [...] ATH9K_AHB ATH9K_BTCOEX_SUPPORT ATH9K_COMMON [...]
-- 
1.8.1.2

