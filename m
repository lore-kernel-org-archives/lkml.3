Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3JXOIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:08:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:57311 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3JXOID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:08:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jiri Kosina <trivial@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] trivial: fix spelling in CONTEXT_TRACKING_FORCE help text
Date: Thu, 24 Oct 2013 10:07:47 -0400
Message-ID: <1382623667-49399-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..a9883f1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -545,7 +545,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks subsystem by forcing the context tracking on all
 	  CPUs in the system.
 
-	  Say Y only if you're working on the developpement of an
+	  Say Y only if you're working on the development of an
 	  architecture backend for the context tracking.
 
 	  Say N otherwise, this option brings an overhead that you
-- 
1.8.4.1

