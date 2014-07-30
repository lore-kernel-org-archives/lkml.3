Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaG3PH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:07:27 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63420 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaG3PHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:07:22 -0400
From: Robert Richter <rric@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Robert Richter <rrichter@cavium.com>
Subject: [PATCH 4/5] arm64, defconfig: Enable Cavium Thunder SoC in defconfig
Date: Wed, 30 Jul 2014 17:06:33 +0200
Message-Id: <1406732794-20920-5-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406732794-20920-1-git-send-email-rric@kernel.org>
References: <1406732794-20920-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

This patch enables Thunder SoCs in the arm64 defconfig. This is
esp. useful to add Thunder platforms to automated builds based on
arm64 defconfig.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 3421f316f5dc..26c3ab582db5 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -32,6 +32,7 @@ CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_ARCH_THUNDER=y
 CONFIG_ARCH_VEXPRESS=y
 CONFIG_ARCH_XGENE=y
 CONFIG_SMP=y
-- 
2.0.1

