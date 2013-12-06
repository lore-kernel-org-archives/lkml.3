Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3LFTDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 14:03:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55280 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab3LFTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 14:03:51 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] gitignore: Add all.config
Date: Fri,  6 Dec 2013 20:03:46 +0100
Message-Id: <1386356626-7791-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is used by kbuild to force-enable .config values. Ignore it
otherwise git clean kills it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 7e9932e55475..c479bef6910b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -92,3 +92,6 @@ extra_certificates
 signing_key.priv
 signing_key.x509
 x509.genkey
+
+# used by kbuild
+all.config
-- 
1.8.4

