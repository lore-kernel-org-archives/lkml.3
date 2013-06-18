Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab3FRWrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:47:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55575 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab3FRWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:34 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 10/14] kconfig/conf: accept a base-16 seed for randconfig
Date: Wed, 19 Jun 2013 00:45:06 +0200
Message-Id: <e85ac12443da72d79dbf7c55c12e4b16b8923d87.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/conf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index bde5b95..94521c7 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -527,7 +527,7 @@ int main(int ac, char **av)
 			seed_env = getenv("KCONFIG_SEED");
 			if( seed_env && *seed_env ) {
 				char *endp;
-				int tmp = (int)strtol(seed_env, &endp, 10);
+				int tmp = (int)strtol(seed_env, &endp, 0);
 				if (*endp == '\0') {
 					seed = tmp;
 				}
-- 
1.8.1.2

