Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3ITUMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:12:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3ITUMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:12:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Holger Hans Peter Freyther <holger@moiji-mobile.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 85/93] lguest: Point to the right directory for the lguest launcher
Date: Fri, 20 Sep 2013 13:09:20 -0700
Message-Id: <1379707768-1804-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Hans Peter Freyther <holger@moiji-mobile.com>

commit d8cacd3a259bf522ea5e6c4c60eba67ba22f599c upstream.

The code was moved in 07fe9977b6234ede1bd29e10e0323e478860c871 but
the comment was not updated. The reference in drivers/vhost/vhost.c
is left alone as it is historic.

Signed-off-by: Holger Hans Peter Freyther <holger@moiji-mobile.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/lguest/boot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 20a4fd4..db141f2 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -7,8 +7,7 @@
  * kernel and insert a module (lg.ko) which allows us to run other Linux
  * kernels the same way we'd run processes.  We call the first kernel the Host,
  * and the others the Guests.  The program which sets up and configures Guests
- * (such as the example in Documentation/virtual/lguest/lguest.c) is called the
- * Launcher.
+ * (such as the example in tools/lguest/lguest.c) is called the Launcher.
  *
  * Secondly, we only run specially modified Guests, not normal kernels: setting
  * CONFIG_LGUEST_GUEST to "y" compiles this file into the kernel so it knows
-- 
1.8.1.2

