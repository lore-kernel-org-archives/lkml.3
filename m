Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3HEUja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:39:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50698 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755005Ab3HEUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:39:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 0/2] clk: sunxi: Add clock support for the A10s
Date: Mon,  5 Aug 2013 22:39:24 +0200
Message-Id: <1375735167-18031-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small patchset adds support for the gates found in the Allwinner A10s SoC.
Since the gates are the only clock that differ from the other supported
Allwinner SoCs so far, the two patches are quite trivial.

Thanks,
Maxime

Changes from v1:
  - Added missing documentation

Maxime Ripard (2):
  clk: sunxi: Add A10s gates
  ARM: sun5i: dt: Use the A10s gates in the DTSI

 Documentation/devicetree/bindings/clock/sunxi.txt  |  3 +
 .../bindings/clock/sunxi/sun5i-a10s-gates.txt      | 75 ++++++++++++++++++++++
 arch/arm/boot/dts/sun5i-a10s.dtsi                  | 36 ++++-------
 drivers/clk/sunxi/clk-sunxi.c                      | 15 +++++
 4 files changed, 107 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun5i-a10s-gates.txt

-- 
1.8.3.4

