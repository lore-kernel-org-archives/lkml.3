Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaE1QvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:51:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10205 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbaE1QvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:51:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 May 2014 09:44:20 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: [PATCH 0/2] debugfs entries for Tegra clocks
Date: Wed, 28 May 2014 19:51:06 +0300
Message-ID: <1401295868-18697-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces the 'regs' debugfs entry which shows the
contents of all registers related to a clock.

Peter De Schrijver (2):
  clk: tegra: Add debugfs infrastructure
  clk: tegra: periph, PLL and super clk debugfs entries

 drivers/clk/tegra/clk-periph.c |   24 +++++++
 drivers/clk/tegra/clk-pll.c    |  144 +++++++++++++++++++++++++++++++++++++---
 drivers/clk/tegra/clk-super.c  |   24 +++++++
 drivers/clk/tegra/clk.c        |   61 +++++++++++++++++
 drivers/clk/tegra/clk.h        |   11 +++
 5 files changed, 255 insertions(+), 9 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

