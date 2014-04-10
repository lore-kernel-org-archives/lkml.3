Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161067AbaDJNIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:08:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38950 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030776AbaDJNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:08:08 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, linus.walleij@linaro.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 3/5] ARM: berlin: add the pinctrl dependency for the Marvell Berlin SoCs
Date: Thu, 10 Apr 2014 15:07:52 +0200
Message-Id: <1397135274-10764-4-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index d3c5f14dc142..291f1cac6c3d 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -4,6 +4,8 @@ config ARCH_BERLIN
 	select GENERIC_IRQ_CHIP
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
+	select PINCTRL
+	select PINCTRL_BERLIN
 
 if ARCH_BERLIN
 
-- 
1.8.3.2

