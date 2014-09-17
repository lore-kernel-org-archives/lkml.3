Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaIQVHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:07:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41268 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbaIQVHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:07:10 -0400
From: Julien Grall <julien.grall@linaro.org>
To: xen-devel@lists.xenproject.org
Cc: ian.campbell@citrix.com, tim@xen.org, stefano.stabellini@citrix.com,
        Julien Grall <julien.grall@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm{,64}/xen: Remove "EXPERIMENTAL" in the description of the Xen options
Date: Wed, 17 Sep 2014 14:07:06 -0700
Message-Id: <1410988026-19949-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen ARM API is stable since Xen 4.4 and everything has been
upstreamed in Linux for ARM and ARM64. Therefore we can drop "EXPERIMENTAL"
from the Xen option in the both Kconfig.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig   | 2 +-
 arch/arm64/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32cbbd5..aa97108 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1758,7 +1758,7 @@ config XEN_DOM0
 	depends on XEN
 
 config XEN
-	bool "Xen guest support on ARM (EXPERIMENTAL)"
+	bool "Xen guest support on ARM"
 	depends on ARM && AEABI && OF
 	depends on CPU_V7 && !CPU_V6
 	depends on !GENERIC_ATOMIC64
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd4e81a..82bd86c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -317,7 +317,7 @@ config XEN_DOM0
 	depends on XEN
 
 config XEN
-	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
+	bool "Xen guest support on ARM64"
 	depends on ARM64 && OF
 	select SWIOTLB_XEN
 	help
-- 
1.9.3

