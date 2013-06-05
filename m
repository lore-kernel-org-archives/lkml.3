Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab3FEOJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:09:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16925 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3FEOJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:09:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Jun 2013 07:08:21 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Override bits for PLLM
Date: Wed, 5 Jun 2013 17:08:25 +0300
Message-ID: <1370441329-8619-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLLM has override bits on Tegra30 and Tegra114. This patchset implements
support for them for both Tegra30 and Tegra114.

Peter De Schrijver (4):
  CHROMIUM: clk: tegra: Add fields for override bits
  CHROMIUM: clk: tegra: override bits for Tegra114 PLLM
  CHROMIUM: clk: tegra: override bits for Tegra30 PLLM
  CHROMIUM: clk: tegra: Use override bits when needed

 drivers/clk/tegra/clk-pll.c      |   82 ++++++++++++++++++++++---------------
 drivers/clk/tegra/clk-tegra114.c |   15 +++++++
 drivers/clk/tegra/clk-tegra30.c  |   18 ++++++++
 drivers/clk/tegra/clk.h          |    8 ++++
 4 files changed, 90 insertions(+), 33 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

