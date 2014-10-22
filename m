Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417AbaJVL5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:57:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48653 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJVL5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:57:41 -0400
From: Zhou Wang <wangzhou.bry@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Wei Xu <xuwei5@hisilicon.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        Zhou Wang <wangzhou.bry@gmail.com>
Subject: [PATCH v1 1/2] ARM: hip04: set ARCH_NR_GPIO to 128
Date: Wed, 22 Oct 2014 19:55:59 +0800
Message-Id: <1413978960-10717-2-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413978960-10717-1-git-send-email-wangzhou.bry@gmail.com>
References: <1413978960-10717-1-git-send-email-wangzhou.bry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set ARCH_NR_GPIO for Hisilicon Soc Hip04, which has 4 GPIO
controllers with 32 GPIOs each.

Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 89c4b5c..26aae1e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1509,6 +1509,7 @@ config ARCH_NR_GPIO
 	default 352 if ARCH_VT8500
 	default 288 if ARCH_ROCKCHIP
 	default 264 if MACH_H4700
+	default 128 if ARCH_HIP04
 	default 0
 	help
 	  Maximum number of GPIOs in the system.
-- 
1.7.9.5

