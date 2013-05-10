Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3EJObn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:31:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57224 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158Ab3EJOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.258040042@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [045/118] ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7f3e3c7cfcec148ccca9c0dd2dbfd7b00b7ac10f upstream.

Fox the Kconfig documentation for CONFIG_EXT4_DEBUG to match the
change made by commit a0b30c1229: ext4: use module parameters instead
of debugfs for mballoc_debug

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -82,4 +82,5 @@ config EXT4_DEBUG
 	  Enables run-time debugging support for the ext4 filesystem.
 
 	  If you select Y here, then you will be able to turn on debugging
-	  with a command such as "echo 1 > /sys/kernel/debug/ext4/mballoc-debug"
+	  with a command such as:
+		echo 1 > /sys/module/ext4/parameters/mballoc_debug

