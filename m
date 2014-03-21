Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaCUTjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:39:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58590 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751352AbaCUTj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:39:27 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] ARM: multi_v7_defconfig: Select CONFIG_MACH_BERLIN_BG2Q
Date: Fri, 21 Mar 2014 20:39:17 +0100
Message-Id: <1395430757-8677-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1395430757-8677-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we support Berlin BG2Q, select CONFIG_MACH_BERLIN_BG2Q so that we can
boot BG2Q based boards like the BG2Q DMP.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index ee6982976d66..8b09b72fb688 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -15,6 +15,7 @@ CONFIG_ARCH_BCM_MOBILE=y
 CONFIG_ARCH_BERLIN=y
 CONFIG_MACH_BERLIN_BG2=y
 CONFIG_MACH_BERLIN_BG2CD=y
+CONFIG_MACH_BERLIN_BG2Q=y
 CONFIG_GPIO_PCA953X=y
 CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_HI3xxx=y
-- 
1.8.3.2

