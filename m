Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab3FFKt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:49:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7892 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3FFKt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:49:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 06 Jun 2013 03:49:31 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] Override bits for PLLM
Date: Thu, 6 Jun 2013 13:47:27 +0300
Message-ID: <1370515677-6807-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLM has override bits on Tegra30 and Tegra114. This patchset implements
support for them for both Tegra30 and Tegra114.

Changes since v1:
 * Remove some stray lines from 'clk: tegra: override bits for Tegra114 PLLM'

Peter De Schrijver (4):
  clk: tegra: Add fields for override bits
  clk: tegra: override bits for Tegra114 PLLM
  clk: tegra: override bits for Tegra30 PLLM
  clk: tegra: Use override bits when needed

 drivers/clk/tegra/clk-pll.c      |   82 ++++++++++++++++++++++---------------
 drivers/clk/tegra/clk-tegra114.c |    9 ++++
 drivers/clk/tegra/clk-tegra30.c  |   18 ++++++++
 drivers/clk/tegra/clk.h          |    8 ++++
 4 files changed, 84 insertions(+), 33 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

