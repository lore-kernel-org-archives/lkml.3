Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030388AbaGCJYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030340AbaGCJYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 144/198] net: filter: fix sparc32 typo
Date: Thu,  3 Jul 2014 10:19:47 +0100
Message-Id: <1404379241-8590-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

commit 588f5d629b3369aba88f52217d1c473a28fa7723 upstream.

Fixes: 569810d1e327 ("net: filter: fix typo in sparc BPF JIT")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/net/bpf_jit_comp.c b/arch/sparc/net/bpf_jit_comp.c
index f90ea700a4b8..560da4d0b4e4 100644
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

