Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab3FRWqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:46:47 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:51339 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933809Ab3FRWpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:36 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 11/14] kconfig/conf: print the seed used to initialise the RNG for randconfig
Date: Wed, 19 Jun 2013 00:45:07 +0200
Message-Id: <a5f6d795f5941e97e757b643a6482968a66c6150.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

... so the user has a chance to reproduce a test-case.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/conf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 94521c7..38616c1 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -532,6 +532,7 @@ int main(int ac, char **av)
 					seed = tmp;
 				}
 			}
+			fprintf( stderr, "KCONFIG_SEED=0x%X\n", seed );
 			srand(seed);
 			break;
 		}
-- 
1.8.1.2

