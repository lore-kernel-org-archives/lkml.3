Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3JaGuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:50:09 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:59363 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3JaGuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:50:07 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, lee.jones@linaro.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 0/4] Add support for clocks in S5M8767
Date: Thu, 31 Oct 2013 12:18:40 +0530
Message-Id: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5M8767 chip has 3 crystal oscillators which are operated in the same
as the crystal oscillators in S2MPS11. Extend s2mps11-clk driver to
support clocks in S5M8767.

The patches are based on next-20131030.

Tushar Behera (4):
  clk: clk-s2mps11: Refactor for including support for other MFD clocks
  clk: clk-s2mps11: Add support for clocks in S5M8767 MFD
  mfd: sec-core: Add cells for S5M8767-clocks
  ARM: dts: Add S5M8767 clock nodes on Arndale board

 arch/arm/boot/dts/exynos5250-arndale.dts |    7 +++++++
 drivers/clk/Kconfig                      |    6 ++++--
 drivers/clk/clk-s2mps11.c                |   25 +++++++++++++++++++++----
 drivers/mfd/sec-core.c                   |    4 +++-
 4 files changed, 35 insertions(+), 7 deletions(-)

-- 
1.7.9.5

