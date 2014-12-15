Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaLOUXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:23:40 -0500
Received: from syn.loicp.eu ([176.31.96.212]:34525 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaLOUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:23:39 -0500
Date: Mon, 15 Dec 2014 21:23:35 +0100
From: Loic Pefferkorn <loic@loicp.eu>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Update CONFIG_DM_CRYPT help-text link
Message-ID: <81c1a7329d2146d37b22d7efa96b3a449cb66d14.1418674665.git.loic@loicp.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch fixes the obsolete help-text link of CONFIG_DM_CRYPT.
Applies against next-20141215.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=75111

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/md/Kconfig | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6..09c89a4b 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -230,9 +230,8 @@ config DM_CRYPT
 	  transparently encrypts the data on it. You'll need to activate
 	  the ciphers you're going to use in the cryptoapi configuration.
 
-	  Information on how to use dm-crypt can be found on
-
-	  <http://www.saout.de/misc/dm-crypt/>
+	  For further information on dm-crypt and userspace tools see:
+	  <http://code.google.com/p/cryptsetup/wiki/DMCrypt>
 
 	  To compile this code as a module, choose M here: the module will
 	  be called dm-crypt.
-- 
2.1.3

