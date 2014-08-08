Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbaHHUw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:52:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852AbaHHUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:51 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 218/259] net: filter: fix sparc32 typo
Date: Fri,  8 Aug 2014 13:40:41 -0700
Message-Id: <1407530482-4483-219-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit 588f5d629b3369aba88f52217d1c473a28fa7723 ]

Fixes: 569810d1e327 ("net: filter: fix typo in sparc BPF JIT")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/net/bpf_jit_comp.c b/arch/sparc/net/bpf_jit_comp.c
index 649828f..44d258d 100644
--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -85,7 +85,7 @@ static void bpf_flush_icache(void *start_, void *end_)
 #ifdef CONFIG_SPARC64
 #define BE_PTR		(F2(0, 1) | CONDE | (2 << 20))
 #else
-#define BE_PTR		BNE
+#define BE_PTR		BE
 #endif
 
 #define SETHI(K, REG)	\
-- 
1.9.1

