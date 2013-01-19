Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3ASAyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:54:53 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64441 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3ASAyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:54:51 -0500
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH next-20130118 2/2] KEYS: MODSIGN: Fix wrong select in MODULE_SIG Kconfig
Date: Sat, 19 Jan 2013 01:54:31 +0100
Message-Id: <1358556871-6651-2-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
References: <1358556871-6651-1-git-send-email-sedat.dilek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There exists no SYSTEM_TRUSTED_KEYS Kconfig option but
SYSTEM_TRUSTED_KEYRING.

Tested against Linux-Next (next-20130118).

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index f7e1b32..7191ccf 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1689,7 +1689,7 @@ config MODULE_SRCVERSION_ALL
 config MODULE_SIG
 	bool "Module signature verification"
 	depends on MODULES
-	select SYSTEM_TRUSTED_KEYS
+	select SYSTEM_TRUSTED_KEYRING
 	select KEYS
 	select CRYPTO
 	select ASYMMETRIC_KEY_TYPE
-- 
1.8.1.1

