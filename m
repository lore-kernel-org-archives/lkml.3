Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651Ab3IDOVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:21:19 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13921 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3IDOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:21:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Sep 2013 07:18:05 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/4] Introduce table driven initializations
Date: Wed, 4 Sep 2013 17:20:07 +0300
Message-ID: <1378304438-7780-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a table driven initialization method for the
audio, PMC and gate clocks. It's similar to the table we already have for                                                                                      
the periph clocks.                                                                                                                                             

Changes since v1:

* Use parent names directly in TEGRA_INIT_DATA_GATE()

Peter De Schrijver (4):
  clk: tegra: simplify periph clock data
  clk: tegra: convert Tegra114 gate clocks to table
  clk: tegra114: table driven audio clock init
  clk: tegra114: table driven PMC clock init

 drivers/clk/tegra/clk-tegra114.c |  892 +++++++++++++++-----------------------
 drivers/clk/tegra/clk-tegra20.c  |    4 +-
 drivers/clk/tegra/clk-tegra30.c  |    4 +-
 drivers/clk/tegra/clk.h          |   93 ++++-
 4 files changed, 436 insertions(+), 557 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

