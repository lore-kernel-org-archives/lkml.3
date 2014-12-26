Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaLZJzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:55:14 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:33773 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbaLZJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:55:08 -0500
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
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ARM: mediatek: Add MT8135 and MT8127 UART support 
Date: Fri, 26 Dec 2014 17:54:59 +0800
Message-ID: <1419587701-13451-1-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.19-rc1 contains Joe's MT8135 & MT8127 basic support and sysirq driver patch.
But still can not boot to shell due to lack UART device node in device tree.
This patch enables MTK UART driver in multi_v7_defconfig and UART device node.

This patch base on 3.19-rc1, and Joe's sysirq dts patch [1]

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305812.html

Eddie Huang (2):
  ARM: mediatek: add UART dts for mt8127 and mt8135
  ARM: Add mediatek SoC UART support in defconfig

 arch/arm/boot/dts/mt8127.dtsi       | 34 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/mt8135.dtsi       | 34 ++++++++++++++++++++++++++++++++++
 arch/arm/configs/multi_v7_defconfig |  1 +
 3 files changed, 69 insertions(+)

--
1.8.1.1.dirty

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
