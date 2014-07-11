Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaGKME0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:04:26 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59386 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaGKMEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:04:23 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, t.figa@samsung.com,
        trblinux@gmail.com
Subject: [PATCH V2 0/3] clk: exynos-audss: Adapt to exising clock framework
Date: Fri, 11 Jul 2014 17:30:32 +0530
Message-Id: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic cleanup and usage of samsung clock register/unregister APIs.

The patches are tested on Exynos5800 based Peach-Pi board. More tests are
welcome.

Tushar Behera (3):
  clk: exynos-audss: Simplify code to get clock names
  clk: samsung: Add API to unregister clocks
  clk: exynos-audss: Use samsung clock APIs to register/unregister
    clocks

 drivers/clk/samsung/clk-exynos-audss.c |  179 +++++++++++++-------------------
 drivers/clk/samsung/clk.c              |   19 ++++
 drivers/clk/samsung/clk.h              |    2 +
 3 files changed, 95 insertions(+), 105 deletions(-)

-- 
1.7.9.5

