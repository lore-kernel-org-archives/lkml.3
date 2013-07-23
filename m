Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab3GWW36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:29:58 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51836 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308Ab3GWW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:29:55 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] clk: sunxi: Add clock support for the A10s
Date: Wed, 24 Jul 2013 00:28:22 +0200
Message-Id: <1374618504-19391-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small patchset adds support for the gates found in the Allwinner A10s SoC.
Since the gates are the only clock that differ from the other supported
Allwinner SoCs so far, the two patches are quite trivial.

Thanks,
Maxime

Maxime Ripard (2):
  clk: sunxi: Add A10s gates
  ARM: sun5i: dt: Use the A10s gates in the DTSI

 arch/arm/boot/dts/sun5i-a10s.dtsi | 36 ++++++++++++++----------------------
 drivers/clk/sunxi/clk-sunxi.c     | 15 +++++++++++++++
 2 files changed, 29 insertions(+), 22 deletions(-)

-- 
1.8.3.2

