Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3LQPwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:52:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab3LQPty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:54 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, sparclinux@vger.kernel.org
Subject: [PATCH v2 07/10] sparc: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Tue, 17 Dec 2013 10:48:50 -0500
Message-Id: <1387295333-24684-8-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: "David S. Miller" <davem@davemloft.net>
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

