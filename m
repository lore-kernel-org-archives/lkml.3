Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3ASJiK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 04:38:10 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17763 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3ASJiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 04:38:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 Jan 2013 01:37:58 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: DTS: seaboard: remove unnecessarily text
Date: Sat, 19 Jan 2013 15:07:44 +0530
Message-ID: <1358588264-1860-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is unnecessarily text in the keymap table. Removing this.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra20-seaboard.dts |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 2e87330..d4e4ff2 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -705,7 +705,7 @@
 				0x0E030010	/* KEY_Q */
 				0x0E04003E	/* KEY_F4 */
 				0x0E05003D	/* KEY_F3 */
-				0x0E060002	/* KEY_1 */1
+				0x0E060002	/* KEY_1 */
 				0x0E070041	/* KEY_F7 */
 
 				0x0F000001	/* KEY_ESC */
-- 
1.7.1.1

