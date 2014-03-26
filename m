Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaCZCaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 22:30:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9603 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaCZCaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 22:30:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Mar 2014 19:26:06 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: <arm@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 2/2] ARM: enable fhandle in multi_v7_defconfig
Date: Wed, 26 Mar 2014 11:29:32 +0900
Message-ID: <1395800972-26483-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395800972-26483-1-git-send-email-acourbot@nvidia.com>
References: <1395800972-26483-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_FHANDLE is required by systemd >= 210 to spawn a serial TTY.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index dc02635ca473..cee30d8d253c 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1,4 +1,5 @@
 CONFIG_SYSVIPC=y
+CONFIG_FHANDLE=y
 CONFIG_IRQ_DOMAIN_DEBUG=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
-- 
1.9.1

