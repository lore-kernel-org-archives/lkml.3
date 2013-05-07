Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3EGNyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:54:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129Ab3EGNmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/118] ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
Date: Tue,  7 May 2013 14:39:01 +0100
Message-Id: <1367933964-1564-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7f3e3c7cfcec148ccca9c0dd2dbfd7b00b7ac10f upstream.

Fox the Kconfig documentation for CONFIG_EXT4_DEBUG to match the
change made by commit a0b30c1229: ext4: use module parameters instead
of debugfs for mballoc_debug

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index c22f170..e38370b 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -84,4 +84,5 @@ config EXT4_DEBUG
 	  Enables run-time debugging support for the ext4 filesystem.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+	  with a command such as:
+		echo 1 > /sys/module/ext4/parameters/mballoc_debug
-- 
1.8.1.2

