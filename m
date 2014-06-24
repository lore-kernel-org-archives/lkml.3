Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaFXPwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:52:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaFXPwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 17/52] net: filter: fix sparc32 typo
Date: Tue, 24 Jun 2014 11:50:32 -0400
Message-Id: <20140624154714.527111878@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit 588f5d629b3369aba88f52217d1c473a28fa7723 ]

Fixes: 569810d1e327 ("net: filter: fix typo in sparc BPF JIT")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/net/bpf_jit_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/net/bpf_jit_comp.c
+++ b/arch/sparc/net/bpf_jit_comp.c
@@ -85,7 +85,7 @@ static void bpf_flush_icache(void *start
 #ifdef CONFIG_SPARC64
 #define BE_PTR		(F2(0, 1) | CONDE | (2 << 20))
 #else
-#define BE_PTR		BNE
+#define BE_PTR		BE
 #endif
 
 #define SETHI(K, REG)	\


