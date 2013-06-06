Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab3FFLgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:36:49 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44328 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3FFLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:36:47 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 0/2] Clock update for EXYNOS4210-CPUFREQ driver
Date: Thu,  6 Jun 2013 16:52:26 +0530
Message-Id: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq driver for EXYNOS4 based SoCs are not platform drivers, hence
we cannot currently pass the clock names through a device tree node.
Instead, we need to make them available through global alias.

The patches are based on next-20130606.

Tushar Behera (2):
  clk: samsung: Add MUX_FA macro to pass flag and alias
  clk: exynos4210: Add alias for cpufreq related clocks

 drivers/clk/samsung/clk-exynos4.c |   10 +++++-----
 drivers/clk/samsung/clk.h         |    3 +++
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
1.7.9.5

