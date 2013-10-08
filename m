Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3JHFNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab3JHFMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:12:37 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH v2 02/14] arc: select ARCH_MAY_HAVE_PC_PARPORT
Date: Tue,  8 Oct 2013 01:10:18 -0400
Message-Id: <1381209030-351-3-git-send-email-msalter@redhat.com>
In-Reply-To: <1381209030-351-1-git-send-email-msalter@redhat.com>
References: <1381209030-351-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which support CONFIG_PARPORT_PC should select
ARCH_MAY_HAVE_PC_PARPORT.

Signed-off-by: Mark Salter <msalter@redhat.com>
CC: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 91dbb27..484b1a7 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -8,6 +8,7 @@
 
 config ARC
 	def_bool y
+	select ARCH_MAY_HAVE_PC_PARPORT
 	select CLONE_BACKWARDS
 	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
 	select DEVTMPFS if !INITRAMFS_SOURCE=""
-- 
1.8.3.1

