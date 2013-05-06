Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab3EFW7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:59:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759168Ab3EFW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 41/46] ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG
Date: Mon,  6 May 2013 15:58:47 -0700
Message-Id: <20130506225824.974431033@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 7f3e3c7cfcec148ccca9c0dd2dbfd7b00b7ac10f upstream.

Fox the Kconfig documentation for CONFIG_EXT4_DEBUG to match the
change made by commit a0b30c1229: ext4: use module parameters instead
of debugfs for mballoc_debug

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


