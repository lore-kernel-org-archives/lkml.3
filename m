Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaBEXxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:53:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36089 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaBEXxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:53:07 -0500
Date: Thu, 6 Feb 2014 00:53:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH -v1.1] gitignore: Add all.config
Message-ID: <20140205235304.GC6364@pd.tnic>
References: <1386356626-7791-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386356626-7791-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is used by kbuild to load preset Kconfig options. We need to ignore
it, otherwise git clean kills it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 7e9932e55475..42fa0d5626a9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -92,3 +92,6 @@ extra_certificates
 signing_key.priv
 signing_key.x509
 x509.genkey
+
+# Kconfig presets
+all.config
-- 
1.8.5.2.192.g7794a68


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
