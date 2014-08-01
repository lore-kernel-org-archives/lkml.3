Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaHALZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:25:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37387 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbaHALZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:25:33 -0400
Message-ID: <53DB7910.1010808@ti.com>
Date: Fri, 1 Aug 2014 14:25:04 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, <arm@kernel.org>
CC: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [REBASED PATCH] ARM: multi_v7_defconfig: Enable TI PIPE3 PHY driver
References: <1406540737-9493-1-git-send-email-rogerq@ti.com> <1406625328-26112-1-git-send-email-rogerq@ti.com> <20140730195242.GF18384@quad.lixom.net>
In-Reply-To: <20140730195242.GF18384@quad.lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

This driver is needed by SATA, PCIe and USB modules on TI SoCs.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 8403b9c..18fb2aa 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -383,6 +383,7 @@ CONFIG_PWM=y
 CONFIG_PWM_TEGRA=y
 CONFIG_PWM_VT8500=y
 CONFIG_OMAP_USB2=y
+CONFIG_TI_PIPE3=y
 CONFIG_PHY_MIPHY365X=y
 CONFIG_PHY_SUN4I_USB=y
 CONFIG_EXT4_FS=y
-- 
1.8.3.2

