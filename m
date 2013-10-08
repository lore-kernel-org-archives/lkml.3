Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3JHFN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3JHFMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:43 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Subject: [PATCH v2 10/14] sh: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:26 -0400
Message-Id: <1381209030-351-11-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: linux-sh@vger.kernel.org
---
 arch/sh/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 224f4bc..a5d1d2e 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -1,5 +1,6 @@
 config SUPERH
 	def_bool y
+	select ARCH_MAY_HAVE_PC_PARPORT
 	select EXPERT
 	select CLKDEV_LOOKUP
 	select HAVE_IDE if HAS_IOPORT
-- 
1.8.3.1

