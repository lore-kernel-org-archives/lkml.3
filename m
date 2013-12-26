Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3LZKWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:22:33 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:53536 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3LZKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:22:32 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, lee.jones@linaro.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH RESEND 0/4] Add support for clocks in S5M8767
Date: Thu, 26 Dec 2013 15:48:57 +0530
Message-Id: <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S5M8767 chip has 3 crystal oscillators which are operated in the same
as the crystal oscillators in S2MPS11. Extend s2mps11-clk driver to
support clocks in S5M8767.

The earlier set of patches no longer apply cleanly on linux-next, hence
rebased them on top of next-20131224.

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

