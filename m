Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaELQ0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:26:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60037 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752102AbaELQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:26:33 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Bo Shen <voice.shen@atmel.com>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/4] ARM: at91: move sam9n12 SoC and boards to the CCF
Date: Mon, 12 May 2014 18:26:26 +0200
Message-Id: <1399911990-5086-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series moves the at91sam9n12 SoC and the at91sam9n12-ek board to
the Common Clock Framework.

It depends on these series: [1], [2].

Best Regards,

Boris

[1] http://lkml.iu.edu/hypermail/linux/kernel/1403.3/00074.html
[2] http://comments.gmane.org/gmane.linux.kernel.samsung-soc/27632

Boris BREZILLON (4):
  ARM: at91: prepare common clk transition for sam9n12 SoC
  ARM: at91/dt: define sam9n12 clocks
  ARM: at91/dt: define sam9n12ek crystal frequencies
  ARM: at91: move sam9n12 SoC to the CCF

 arch/arm/boot/dts/at91sam9n12.dtsi  | 348 +++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/at91sam9n12ek.dts |   8 +
 arch/arm/mach-at91/Kconfig          |   1 -
 arch/arm/mach-at91/at91sam9n12.c    |   6 +-
 4 files changed, 359 insertions(+), 4 deletions(-)

-- 
1.8.3.2

