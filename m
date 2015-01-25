Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbbAYNal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:30:41 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57321 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbbAYNab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:30:31 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 1/2] tools/liblockdep: ignore generated .so file
Date: Sun, 25 Jan 2015 15:30:22 +0200
Message-Id: <d6ba76fc891265ddb1b4e0fec6c76aac8168ba01.1422192349.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 tools/lib/lockdep/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/lib/lockdep/.gitignore

diff --git a/tools/lib/lockdep/.gitignore b/tools/lib/lockdep/.gitignore
new file mode 100644
index 000000000000..cc0e7a9f99e3
--- /dev/null
+++ b/tools/lib/lockdep/.gitignore
@@ -0,0 +1 @@
+liblockdep.so.*
-- 
2.1.4

