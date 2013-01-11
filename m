Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3AKNdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:33:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1036 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3AKNdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:33:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 11 Jan 2013 05:33:23 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] ARM: tegra: config: enable KEYBOARD_TEGRA
Date: Fri, 11 Jan 2013 19:03:04 +0530
Message-ID: <1357911185-11048-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com>
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 254f31f..e350afb 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -107,6 +107,7 @@ CONFIG_BRCMFMAC=m
 CONFIG_RT2X00=y
 CONFIG_RT2800USB=m
 CONFIG_INPUT_EVDEV=y
+CONFIG_KEYBOARD_TEGRA=y
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_MPU3050=y
 # CONFIG_LEGACY_PTYS is not set
-- 
1.7.1.1

