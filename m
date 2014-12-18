Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaLRIeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:34:06 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:58468 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363AbaLRIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:34:04 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Alan Cox <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <yingjoe.chen@mediatek.com>, <yh.chen@mediatek.com>
Subject: [PATCH 0/2] tty: serial: Add earlycon support to MT8173 SoC
Date: Thu, 18 Dec 2014 16:33:19 +0800
Message-ID: <1418891601-53769-1-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add earlycon support to Mediatek MT8173 SoC. Although 8250 driver
already has earlycon support, but Mediatek UART has highspeed register that
not in 8250_early.c, so I port earlycon in 8250_mtk.c, and add stdout device
tree support.

This patchset is based on 3.18, and my basic support for Mediatek MT8173 Soc [1].

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/311238.html

Eddie Huang (2):
  tty: serial: 8250_mtk: Add earlycon
  arm64: dts: Add mediatek MT8173 earlycon support

 arch/arm64/boot/dts/mt8173-evb.dts |  4 +++-
 drivers/tty/serial/8250/8250_mtk.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)

--
1.8.1.1.dirty

