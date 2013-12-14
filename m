Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3LNRHy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:07:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab3LNRHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:07:52 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: [PATCH 07/10] sparc: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Sat, 14 Dec 2013 11:59:33 -0500
Message-Id: <1387040376-26906-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1387040376-26906-1-git-send-email-msalter@redhat.com>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index d4f7a6a..034a680 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -13,6 +13,7 @@ config SPARC
 	bool
 	default y
 	select ARCH_MIGHT_HAVE_PC_PARPORT if SPARC64 && PCI
+	select ARCH_MIGHT_HAVE_PC_SERIO
 	select OF
 	select OF_PROMTREE
 	select HAVE_IDE
-- 
1.8.3.1

