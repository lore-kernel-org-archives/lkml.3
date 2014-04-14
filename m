Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbaDNX6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:58:00 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:31122 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaDNX53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:57:29 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, davidlohr@hp.com,
        aswin@hp.com
Subject: [PATCH 1/3] mm: fix CONFIG_DEBUG_VM_RB description
Date: Mon, 14 Apr 2014 16:57:19 -0700
Message-Id: <1397519841-24847-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397519841-24847-1-git-send-email-davidlohr@hp.com>
References: <1397519841-24847-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This appears to be a copy/paste error. Update the description
to reflect extra rbtree debug and checks for the config option
instead of duplicating CONFIG_DEBUG_VM.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 lib/Kconfig.debug | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 140b66a..819ac51 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -505,8 +505,7 @@ config DEBUG_VM_RB
 	bool "Debug VM red-black trees"
 	depends on DEBUG_VM
 	help
-	  Enable this to turn on more extended checks in the virtual-memory
-	  system that may impact performance.
+	  Enable VM red-black tree debugging information and extra validations.
 
 	  If unsure, say N.
 
-- 
1.8.1.4

