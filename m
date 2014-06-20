Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967195AbaFTLtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:49:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63819 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966096AbaFTLtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:49:18 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, grant.likely@linaro.org,
        matthias.bgg@gmail.com, thierry.reding@gmail.com,
        florian.vaussard@epfl.ch, jic23@kernel.org, jason@lakedaemon.net,
        andrew@lunn.ch, silvio.fricke@gmail.com, heiko.stuebner@bq.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        shawn.guo@freescale.com, anders.berg@lsi.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 0/3] arm: Add basic support for Mediatek Cortex-A7 SoCs
Date: Fri, 20 Jun 2014 13:48:46 +0200
Message-Id: <1403264929-21325-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes just the patches for the timer driver.
They are rebased against tip/timers/core from the tip repository [0].

The only change applied are line shifts in the OF patch.

I will send the rest of the series as a pull-request.

[0] git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git


Matthias Brugger (3):
  of: Provide function to request and map memory
  clocksource: Add support for the Mediatek SoCs
  dt-bindings: add mtk-timer bindings

 .../bindings/timer/mediatek,mtk-timer.txt          |   18 ++
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/mtk_timer.c                    |  261 ++++++++++++++++++++
 drivers/of/address.c                               |   29 +++
 include/linux/of_address.h                         |    8 +
 6 files changed, 322 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
 create mode 100644 drivers/clocksource/mtk_timer.c

-- 
1.7.9.5

