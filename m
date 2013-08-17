Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3HQTIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:08:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50977 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754171Ab3HQTIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:08:53 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] clk: sunxi: Add support for the A20 clocks
Date: Sat, 17 Aug 2013 21:08:41 +0200
Message-Id: <1376766523-9107-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set adds support for the basic clocks found on the Allwinner A20 SoC.
The A20 is on a general basis pretty close to the A10, and this also applies to the clocks.

That allows us to actually reuse a lot of the clocks found there, except for the
gates.

These patches add those gates and the associated documentation for the A20.

Thanks,
Maxime

Maxime Ripard (2):
  clk: sunxi: Add Allwinner A20 gates
  ARM: sun7i: Enable the A20 clocks in the DTSI

 Documentation/devicetree/bindings/clock/sunxi.txt  |   3 +
 .../bindings/clock/sunxi/sun7i-a20-gates.txt       |  98 ++++++++++++++++
 arch/arm/boot/dts/sun7i-a20.dtsi                   | 126 +++++++++++++++++++--
 drivers/clk/sunxi/clk-sunxi.c                      |  15 +++
 4 files changed, 232 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun7i-a20-gates.txt

-- 
1.8.3.4

