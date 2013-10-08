Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3JHFMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3JHFMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:33 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, linux-alpha@vger.kernel.org
Subject: [PATCH v2 01/14] alpha: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:17 -0400
Message-Id: <1381209030-351-2-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
Acked-by: Richard Henderson <rth@twiddle.net>
CC: linux-alpha@vger.kernel.org
---
 arch/alpha/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 35a300d..626949c 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -1,6 +1,7 @@
 config ALPHA
 	bool
 	default y
+	select ARCH_MAY_HAVE_PC_PARPORT
 	select HAVE_AOUT
 	select HAVE_IDE
 	select HAVE_OPROFILE
-- 
1.8.3.1

