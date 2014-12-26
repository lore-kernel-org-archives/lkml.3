Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaLZJzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:55:35 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33773 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbaLZJzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:55:11 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        <yingjoe.chen@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@nvidia.com>,
        Jason Cooper <jason@lakedaemon.net>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ray Jui <rjui@broadcom.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>
Subject: [PATCH 2/2] ARM: Add mediatek SoC UART support in defconfig
Date: Fri, 26 Dec 2014 17:55:01 +0800
Message-ID: <1419587701-13451-3-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1419587701-13451-1-git-send-email-eddie.huang@mediatek.com>
References: <1419587701-13451-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mediatek SoC UART support in multi_v7_defconfig

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 arch/arm/configs/multi_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 2328fe7..fd0ff95 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -195,6 +195,7 @@ CONFIG_SERIO_AMBAKMI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_DW=y
+CONFIG_SERIAL_8250_MT6577=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_SERIAL_MESON=y
-- 
1.8.1.1

************* Email Confidentiality Notice ********************
The information contained in this e-mail message (including any 
attachments) may be confidential, proprietary, privileged, or otherwise
exempt from disclosure under applicable laws. It is intended to be 
conveyed only to the designated recipient(s). Any use, dissemination, 
distribution, printing, retaining or copying of this e-mail (including its 
attachments) by unintended recipient(s) is strictly prohibited and may 
be unlawful. If you are not an intended recipient of this e-mail, or believe 
that you have received this e-mail in error, please notify the sender 
immediately (by replying to this e-mail), delete any and all copies of 
this e-mail (including any attachments) from your system, and do not
disclose the content of this e-mail to any other person. Thank you!
