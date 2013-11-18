Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab3KRNMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:12:35 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11430 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:12:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Nov 2013 05:06:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rob.herring@calxeda.com>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ashwini Ghuge <aghuge@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: add port FF to GPIO ID's
Date: Mon, 18 Nov 2013 18:40:41 +0530
Message-ID: <1384780241-31639-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ashwini Ghuge <aghuge@nvidia.com>

NVIDIA Tegra124 supports has the new gpio port as GPIO_FF.
Add the macro for this port name.

Signed-off-by: Ashwini Ghuge <aghuge@nvidia.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/dt-bindings/gpio/tegra-gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/dt-bindings/gpio/tegra-gpio.h b/include/dt-bindings/gpio/tegra-gpio.h
index 4d179c0..197dc28 100644
--- a/include/dt-bindings/gpio/tegra-gpio.h
+++ b/include/dt-bindings/gpio/tegra-gpio.h
@@ -43,6 +43,7 @@
 #define TEGRA_GPIO_BANK_ID_CC 28
 #define TEGRA_GPIO_BANK_ID_DD 29
 #define TEGRA_GPIO_BANK_ID_EE 30
+#define TEGRA_GPIO_BANK_ID_FF 31
 
 #define TEGRA_GPIO(bank, offset) \
 	((TEGRA_GPIO_BANK_ID_##bank * 8) + offset)
-- 
1.7.1.1

