Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab3BTTmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:42:15 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:51360 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3BTTl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:41:57 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org
Subject: [RFC/PATCH 5/5] ARM: Kconfig: allow virt CPU accounting
Date: Wed, 20 Feb 2013 11:41:42 -0800
Message-Id: <1361389302-11968-6-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361389302-11968-1-git-send-email-khilman@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 64-bit requirement removed from virt CPU accounting,
allow ARM platforms to enable it.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9bbe760..732f8d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -55,6 +55,7 @@ config ARM
 	select HAVE_MOD_ARCH_SPECIFIC if ARM_UNWIND
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
+	select HAVE_VIRT_CPU_ACCOUNTING
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
-- 
1.8.1.2

