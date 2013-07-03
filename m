Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3GCIOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:14:39 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:11599
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab3GCIOh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:14:37 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzc89bhzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch8275bhz2dh2a8h668h839h93fhd24he5bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH linux-next 1/2] arm: multi_v7_defconfig: add i.MX serial console
Date: Wed, 3 Jul 2013 10:12:58 +0200
Message-ID: <1372839179-14542-2-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372839179-14542-1-git-send-email-vincent.stehle@freescale.com>
References: <1372839179-14542-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i.MX serial console support. This gives us the boot messages on UART on
e.g. the i.MX6Q sabre sd platform.

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/configs/multi_v7_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 6d8d3c4..cc8723a 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -75,6 +75,8 @@ CONFIG_SERIAL_OMAP=y
 CONFIG_SERIAL_OMAP_CONSOLE=y
 CONFIG_SERIAL_XILINX_PS_UART=y
 CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
+CONFIG_SERIAL_IMX=y
+CONFIG_SERIAL_IMX_CONSOLE=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_I2C_SIRF=y
 CONFIG_I2C_TEGRA=y
-- 
1.7.10.4



