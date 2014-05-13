Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaEMAaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:30:14 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48942 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaEMAaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:30:12 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/7] OF init section function prototype fixes
Date: Mon, 12 May 2014 19:29:46 -0500
Message-Id: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This series fixes the function prototypes of various OF initiaiization 
callback functions. I found these when adding type checking. I intend to 
merge this thru the DT tree with the series that adds the type 
checking[1].

Rob

[1] https://lkml.org/lkml/2014/5/8/667

Rob Herring (7):
  ARM: imx: fix function type for CLK_OF_DECLARE
  clk: rockchip: fix function type for CLK_OF_DECLARE
  clk: sunxi: avoid double DT matching
  clk: sunxi: fix function type for CLK_OF_DECLARE
  irqchip: s3c24xx: fix function type for IRQCHIP_OF_DECLARE
  irqchip: mxs: fix function type for IRQCHIP_OF_DECLARE
  clk: ti: add missing semi-colon on CLK_OF_DECLARE

 arch/arm/mach-imx/clk-imx35.c       | 4 +---
 drivers/clk/rockchip/clk-rockchip.c | 3 +--
 drivers/clk/sunxi/clk-sunxi.c       | 5 ++---
 drivers/clk/ti/gate.c               | 2 +-
 drivers/irqchip/irq-mxs.c           | 4 ++--
 drivers/irqchip/irq-s3c24xx.c       | 6 ++----
 6 files changed, 9 insertions(+), 15 deletions(-)

-- 
1.9.1

