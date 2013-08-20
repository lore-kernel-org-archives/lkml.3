Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab3HTQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:16:57 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57321 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HTQQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:16:55 -0400
Subject: [PATCH v3 trivial 4/7] Docs: Kconfig: `devlopers' -> `developers'
Date: Tue, 20 Aug 2013 16:05:19 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Message-ID: <f56c06463b6d42f9bb8642c89bafb32b-mfwitten@gmail.com>
In-Reply-To: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
References: <4cd8ab80726c43cf90243970c20f50ef-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Wed, 14 Aug 2013 09:59:45 +0000

Signed-off-by: Michael Witten <mfwitten@gmail.com>
---
 fs/btrfs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 2b3b832..e374bf9 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -59,7 +59,8 @@ config BTRFS_FS_RUN_SANITY_TESTS
 	help
 	  This will run some basic sanity tests on the free space cache
 	  code to make sure it is acting as it should.  These are mostly
-	  regression tests and are only really interesting to btrfs devlopers.
+	  regression tests and are only really interesting to btrfs
+	  developers.
 
 	  If unsure, say N.
 
-- 
1.7.11.2.252.gc4a64c8

