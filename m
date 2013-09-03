Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab3ICNcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 09:32:02 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4384 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759959Ab3ICNcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 09:32:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Sep 2013 06:29:13 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Joseph Lo <josephl@nvidia.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] Introduce table driven initializations
Date: Tue, 3 Sep 2013 16:31:30 +0300
Message-ID: <1378215105-12145-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver (4):
  clk: tegra: simplify periph clock data
  clk: tegra: convert Tegra114 gate clocks to table
  clk: tegra114: table driven audio clock init
  clk: tegra114: table driven PMC clock init

 drivers/clk/tegra/clk-tegra114.c |  926 ++++++++++++++++----------------------
 drivers/clk/tegra/clk.h          |   79 ++++
 2 files changed, 455 insertions(+), 550 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

