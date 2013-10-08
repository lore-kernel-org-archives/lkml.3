Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3JHFNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab3JHFMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:44 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH v2 12/14] unicore32: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:28 -0400
Message-Id: <1381209030-351-13-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 82cdd89..9e0b8bd 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -1,5 +1,6 @@
 config UNICORE32
 	def_bool y
+	select ARCH_MAY_HAVE_PC_PARPORT
 	select HAVE_MEMBLOCK
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_DMA_ATTRS
-- 
1.8.3.1

