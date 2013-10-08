Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab3JHFNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab3JHFMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:41 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: [PATCH v2 11/14] sparc: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:27 -0400
Message-Id: <1381209030-351-12-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 78c4fdb..362229a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -12,6 +12,7 @@ config 64BIT
 config SPARC
 	bool
 	default y
+	select ARCH_MAY_HAVE_PC_PARPORT if SPARC64 && PCI
 	select OF
 	select OF_PROMTREE
 	select HAVE_IDE
-- 
1.8.3.1

