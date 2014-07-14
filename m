Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaGNPJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:09:50 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48420 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbaGNPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:09:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>
Subject: [PATCH 07/38] Delete unused Kbuild files in include/*
Date: Mon, 14 Jul 2014 17:08:35 +0200
Message-Id: <1405350546-28467-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405350546-28467-1-git-send-email-sam@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
 <1405350546-28467-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following files are not used - and they serve no purpose.
Delete them.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: David Howells <dhowells@redhat.com>
---
 include/Kbuild         | 2 --
 include/scsi/fc/Kbuild | 0
 include/video/Kbuild   | 0
 3 files changed, 2 deletions(-)
 delete mode 100644 include/Kbuild
 delete mode 100644 include/scsi/fc/Kbuild
 delete mode 100644 include/video/Kbuild

diff --git a/include/Kbuild b/include/Kbuild
deleted file mode 100644
index bab1145..0000000
--- a/include/Kbuild
+++ /dev/null
@@ -1,2 +0,0 @@
-# Top-level Makefile calls into asm-$(ARCH)
-# List only non-arch directories below
diff --git a/include/scsi/fc/Kbuild b/include/scsi/fc/Kbuild
deleted file mode 100644
index e69de29..0000000
diff --git a/include/video/Kbuild b/include/video/Kbuild
deleted file mode 100644
index e69de29..0000000
-- 
1.9.3

