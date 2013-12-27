Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3L0Aoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:44:34 -0500
Received: from mail-pa0-f73.google.com ([209.85.220.73]:43256 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3L0Aob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:44:31 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 0/7] misc Tegra clock fixes
Date: Thu, 26 Dec 2013 16:44:20 -0800
Message-Id: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for various clock-related issues found during bringup of
Tegra124-based Venice2 and Norrin boards.

Andrew Bresticker (3):
  clk: tegra: fix sdmmc clks on Tegra1x4
  clk: tegra: cclk_lp has a pllx/2 divider
  clk: tegra: use max divider if divider overflows

David Ung (1):
  clk: tegra: PLLD2 fixes for hdmi

Gabe Black (1):
  clk: tegra: Fix PLLP rate table

Mark Zhang (1):
  clk: tegra: fix host1x clock on Tegra124

Rhyland Klein (1):
  clk: tegra: Fix PLLD mnp table

 drivers/clk/tegra/clk-divider.c          |  2 +-
 drivers/clk/tegra/clk-id.h               |  4 +++
 drivers/clk/tegra/clk-tegra-periph.c     |  4 +++
 drivers/clk/tegra/clk-tegra-super-gen4.c |  2 +-
 drivers/clk/tegra/clk-tegra114.c         |  8 +++---
 drivers/clk/tegra/clk-tegra124.c         | 46 +++++++++++++++++++-------------
 6 files changed, 41 insertions(+), 25 deletions(-)

-- 
1.8.5.1

