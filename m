Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3HGDpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:45:49 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:37344 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab3HGDpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:45:46 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 17/17] Add config EFI_STUB for ARM to Kconfig
Date: Tue,  6 Aug 2013 20:45:13 -0700
Message-Id: <1375847113-24884-18-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/Kconfig |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 37c0f4e..192968c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1805,6 +1805,16 @@ config UACCESS_WITH_MEMCPY
 	  However, if the CPU data cache is using a write-allocate mode,
 	  this option is unlikely to provide any performance gain.
 
+config EFI_STUB
+	bool "EFI stub support"
+	---help---
+	  This kernel feature allows a zImage to be loaded directly
+	  by EFI firmware without the use of a bootloader.  A PE/COFF
+	  header is added to the zImage in a way that makes the binary
+	  both a Linux zImage and an PE/COFF executable that can be
+	  executed directly by EFI firmware.
+	  See Documentation/efi-stub.txt for more information.
+
 config SECCOMP
 	bool
 	prompt "Enable seccomp to safely compute untrusted bytecode"
-- 
1.7.10.4

