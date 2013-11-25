Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3KYNUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:20:46 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9401 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3KYNUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:20:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 25 Nov 2013 05:18:19 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Tegra124 clock fixes
Date: Mon, 25 Nov 2013 15:20:21 +0200
Message-ID: <1385385623-8952-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few fixes for Tegra124 clocks. These patches will be squashed into the pull
request I will send out later today, but I wanted to post them here as well
so the changes are known.

Peter De Schrijver (2):
  clk: tegra: fix vi clk for Terga124
  clk: tegra: fix pllcx pdiv for Tegra124

 drivers/clk/tegra/clk-id.h           |    1 +
 drivers/clk/tegra/clk-tegra-periph.c |    8 ++++++++
 drivers/clk/tegra/clk-tegra124.c     |    5 ++++-
 3 files changed, 13 insertions(+), 1 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

