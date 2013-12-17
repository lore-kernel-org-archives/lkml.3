Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab3LQPt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:49:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939Ab3LQPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:49:53 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>
Subject: [PATCH v2 06/10] sh: select ARCH_MIGHT_HAVE_PC_SERIO for SH_CAYMAN
Date: Tue, 17 Dec 2013 10:48:49 -0500
Message-Id: <1387295333-24684-7-git-send-email-msalter@redhat.com>
In-Reply-To: <1387295333-24684-1-git-send-email-msalter@redhat.com>
References: <1387295333-24684-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectures which might use an i8042 for serial IO to keyboard,
mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO. Cayman board
is only sh board which needs this.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/sh/boards/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index fb58057..eb1cf84 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -321,6 +321,7 @@ config SH_CAYMAN
 	bool "Hitachi Cayman"
 	depends on CPU_SUBTYPE_SH5_101 || CPU_SUBTYPE_SH5_103
 	select SYS_SUPPORTS_PCI
+	select ARCH_MIGHT_HAVE_PC_SERIO
 
 config SH_POLARIS
 	bool "SMSC Polaris"
-- 
1.8.3.1

