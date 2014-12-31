Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaLaPfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:35:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaLaPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:35:35 -0500
From: Michal Marek <mmarek@suse.cz>
To: sedat.dilek@gmail.com
Cc: ben@decadent.org.uk, max@stro.at, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 2/2] kbuild: Drop support for clean-rule
Date: Wed, 31 Dec 2014 16:35:19 +0100
Message-Id: <1420040119-32669-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420040119-32669-1-git-send-email-mmarek@suse.cz>
References: <54A40743.8080401@suse.cz>
 <1420040119-32669-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean-rule has not been used since 94869f86 (kbuild: Accept absolute
paths in clean-files and introduce clean-dirs) ten years ago.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.clean | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
index 627f8cb..55c96cb 100644
--- a/scripts/Makefile.clean
+++ b/scripts/Makefile.clean
@@ -71,9 +71,6 @@ endif
 ifneq ($(strip $(__clean-dirs)),)
 	+$(call cmd,cleandir)
 endif
-ifneq ($(strip $(clean-rule)),)
-	+$(clean-rule)
-endif
 	@:
 
 
-- 
2.1.2

