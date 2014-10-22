Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaJVNRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:17:47 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:40160 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716AbaJVNRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:17:45 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 09:17:44 EDT
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Alan Cox <alan@linux.intel.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <yh.chen@mediatek.com>,
        <hc.yen@mediatek.com>, <nathan.chung@mediatek.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 0/3] tty: serial: Add mediatek MT8127 and MT8135 UART support 
Date: Wed, 22 Oct 2014 21:12:06 +0800
Message-ID: <1413983529-21887-1-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch base on 3.18-rc1, which include mediatek MT65XX SOC
UART driver developed by Matthias Brugger, and
Joe.C's Mediatek MT8127 & MT8135 basic SOC support patch[1].

This patch fix one 8250_mtk.c bug that divisor maybe zero, and add device tree support.
Test ok on MT8127 and MT8135 tablet platform.

Eddie Huang (3):
  tty: serial: Fix mediatek UART driver setting baudrate issue
  ARM: mediatek: add UART dts for mt8127 and mt8135
  DTS: serial: Add bindings document for the Mediatek UARTs

 .../devicetree/bindings/serial/mtk-uart.txt        |  2 ++
 arch/arm/boot/dts/mt8127.dtsi                      | 34 ++++++++++++++++++++
 arch/arm/boot/dts/mt8135.dtsi                      | 36 ++++++++++++++++++++++
 drivers/tty/serial/8250/8250_mtk.c                 |  4 +--
 4 files changed, 74 insertions(+), 2 deletions(-)

