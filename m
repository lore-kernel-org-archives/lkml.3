Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3J1FtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:49:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60495 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752002Ab3J1FtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:49:24 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: mmarek@suse.cz, tkhai@yandex.ru, js1304@gmail.com,
        akpm@linux-foundation.org, schwab@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] scripts/tags.sh: remove obsolete __devinit[const|data]
Date: Mon, 28 Oct 2013 06:49:18 +0100
Message-Id: <1382939358-4971-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the use of __devinitconst and __devinitdata in scripts/tags.sh,
which were removed in 3.8.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 scripts/tags.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 74f02e4..72035c7 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -149,8 +149,8 @@ dogtags()
 exuberant()
 {
 	all_target_sources | xargs $1 -a                        \
-	-I __initdata,__exitdata,__initconst,__devinitdata	\
-	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
+	-I __initdata,__exitdata,__initconst			\
+	-I __cpuinitdata,__initdata_memblock			\
 	-I __refdata,__attribute				\
 	-I __acquires,__releases,__deprecated			\
 	-I __read_mostly,__aligned,____cacheline_aligned        \
-- 
1.8.1.2

