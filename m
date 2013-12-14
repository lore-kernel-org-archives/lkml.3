Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3LNRAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:00:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3LNRAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:00:22 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 08/10] unicore32: select ARCH_MIGHT_HAVE_PC_SERIO
Date: Sat, 14 Dec 2013 11:59:34 -0500
Message-Id: <1387040376-26906-9-git-send-email-msalter@redhat.com>
In-Reply-To: <1387040376-26906-1-git-send-email-msalter@redhat.com>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index a7ba27b..25c0dba 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -1,6 +1,7 @@
 config UNICORE32
 	def_bool y
 	select ARCH_MIGHT_HAVE_PC_PARPORT
+	select ARCH_MIGHT_HAVE_PC_SERIO
 	select HAVE_MEMBLOCK
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_DMA_ATTRS
-- 
1.8.3.1

