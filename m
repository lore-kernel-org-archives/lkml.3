Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3LQPuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:50:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab3LQPt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:57 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 05/10] powerpc: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Tue, 17 Dec 2013 10:48:48 -0500
Message-Id: <1387295333-24684-6-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..fb75485 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -86,6 +86,7 @@ config PPC
 	bool
 	default y
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
 	select OF
 	select OF_EARLY_FLATTREE
-- 
1.8.3.1

