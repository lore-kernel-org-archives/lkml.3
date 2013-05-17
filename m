Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3EQGJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 02:09:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:49481 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3EQGJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 02:09:22 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, thomas.abraham@linaro.org,
        patches@linaro.org
Subject: [PATCH 0/2] Clock changes for supporting CPUFreq on Exynos5250
Date: Fri, 17 May 2013 11:25:51 +0530
Message-Id: <1368770153-29041-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the use of common clock framework, CPUFreq driver on EXYNOS5250 now
requires a few changes in clocks.

Tested on Exynos5250 based Arndale board.
The patches are based on v3.10-rc1.

Tushar Behera (2):
  clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
  clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock

 drivers/clk/samsung/clk-exynos5250.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.9.5

