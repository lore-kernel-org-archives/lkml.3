Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaBGEfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:35:50 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14025 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaBGEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:35:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Feb 2014 20:33:43 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 3/6] ARM: firmware: enable Trusted Foundations by default
Date: Fri, 7 Feb 2014 13:35:03 +0900
Message-ID: <1391747706-1847-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
References: <1391747706-1847-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed previously (https://lkml.org/lkml/2013/11/26/289), enable
Trusted Foundation support by default since it already depends on a
supporting architecture being selected.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/firmware/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/firmware/Kconfig b/arch/arm/firmware/Kconfig
index bb126594995e..ad396af68e47 100644
--- a/arch/arm/firmware/Kconfig
+++ b/arch/arm/firmware/Kconfig
@@ -11,6 +11,7 @@ menu "Firmware options"
 config TRUSTED_FOUNDATIONS
 	bool "Trusted Foundations secure monitor support"
 	depends on ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
+	default y
 	help
 	  Some devices (including most Tegra-based consumer devices on the
 	  market) are booted with the Trusted Foundations secure monitor
-- 
1.8.5.3

