Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaGMKVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:21:07 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:55837 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaGMKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:20:58 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yann Droneaud <ydroneaud@opteya.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Michal Marek <mmarek@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Rob Landley <rob@landley.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCHv1 1/2] Documentation: headers_install.txt is part of kbuild
Date: Sun, 13 Jul 2014 12:15:29 +0200
Message-Id: <bba4e1dd32c0e30b70443d70ff79187683fed9b3.1405246009.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405246007.git.ydroneaud@opteya.com>
References: <cover.1405246007.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1405246007.git.ydroneaud@opteya.com>
References: <20140709204915.GB32335@ravnborg.org> <cover.1405246007.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'headers_install.txt' from Documentation/make/ is related to Kbuild
so it must be moved in Documentation/kbuild/ directory.

As Documentation/make/ directory has only one file, it will be removed
as a consequence of moving 'headers_install.txt'.

Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Marek <mmarek@suse.cz>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 Documentation/kbuild/00-INDEX                      | 2 ++
 Documentation/{make => kbuild}/headers_install.txt | 0
 2 files changed, 2 insertions(+)
 rename Documentation/{make => kbuild}/headers_install.txt (100%)

diff --git a/Documentation/kbuild/00-INDEX b/Documentation/kbuild/00-INDEX
index e8d2b6d83a3d..8c5e6aa78004 100644
--- a/Documentation/kbuild/00-INDEX
+++ b/Documentation/kbuild/00-INDEX
@@ -1,5 +1,7 @@
 00-INDEX
 	- this file: info on the kernel build process
+headers_install.txt
+	- how to export Linux headers for use by userspace
 kbuild.txt
 	- developer information on kbuild
 kconfig.txt
diff --git a/Documentation/make/headers_install.txt b/Documentation/kbuild/headers_install.txt
similarity index 100%
rename from Documentation/make/headers_install.txt
rename to Documentation/kbuild/headers_install.txt
-- 
1.9.3

