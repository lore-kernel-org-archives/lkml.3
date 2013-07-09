Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3GIRzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 13:55:31 -0400
Received: from mail14-co9on0067.outbound.messaging.microsoft.com ([157.56.211.67]:27289
	"EHLO CO9EHSNDR002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752381Ab3GIRz1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 13:55:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-OUTBOUND-SPAM: yes
X-SpamScore: 3
X-BigFish: VS3(zzc89bhzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h15abkzz8275ch17326ah8275bh8275dhz2dh87h2a8h668h839h93fhd24he5bhf0ah1239h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b5bh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h41h42h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
CC: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@freescale.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH linux-next] arm: multi_v7_defconfig: add fsl lpuart serial console
Date: Tue, 9 Jul 2013 19:54:51 +0200
Message-ID: <1373392491-32056-1-git-send-email-vincent.stehle@freescale.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Reply-To: <vstehle@debian>
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Freescale LPUART serial console support. This gives us the boot messages on
UART on e.g. the Vybrid VF610 Tower board.

Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>
---


Hi,

Would you please consider adding LPUART for ARM multi_v7_defconfig, please?

(This patch is built on top of the following patches:
http://comments.gmane.org/gmane.linux.kernel/1519712)

Best regards,

V.


 arch/arm/configs/multi_v7_defconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 81eac83..80aacc6 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -79,6 +79,8 @@ CONFIG_SERIAL_XILINX_PS_UART=y
 CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
 CONFIG_SERIAL_IMX=y
 CONFIG_SERIAL_IMX_CONSOLE=y
+CONFIG_SERIAL_FSL_LPUART=y
+CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
 CONFIG_I2C_DESIGNWARE_PLATFORM=y
 CONFIG_I2C_SIRF=y
 CONFIG_I2C_TEGRA=y
-- 
1.7.10.4



