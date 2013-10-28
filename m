Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3J1K3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:29:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8283 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3J1K3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:29:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 28 Oct 2013 03:28:49 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v9 5/5] ARM: tegra: support Trusted Foundations by default
Date: Mon, 28 Oct 2013 19:28:38 +0900
Message-ID: <1382956118-12495-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
References: <1382956118-12495-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for Trusted Foundations is light and allows the kernel to run on
a wider range of devices, so enable it by default.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/configs/tegra_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index ea042e8..dddb97b 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -32,6 +32,7 @@ CONFIG_PCI=y
 CONFIG_PCI_MSI=y
 CONFIG_PCI_TEGRA=y
 CONFIG_PCIEPORTBUS=y
+CONFIG_TRUSTED_FOUNDATIONS=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
-- 
1.8.4.1

