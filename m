Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3FENwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:52:16 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15967 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab3FENwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:52:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Jun 2013 06:51:48 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: <linux-arm-kernel@lists.infradead.org>, <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] PLL m,n,p init from SoC files
Date: Wed, 5 Jun 2013 16:51:24 +0300
Message-ID: <1370440301-3562-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The m,n,p fields don't have the same bit offset and width across all PLLs.
This patchset allows SoC specific files to indicate the offset and width.
It also provides the data for Tegra114.

Peter De Schrijver (2):
  clk: tegra: allow PLL m,n,p init from SoC files
  clk: tegra: PLL m,n,p init for Tegra114

 drivers/clk/tegra/clk-pll.c      |   60 ++++++++++++++++-------------
 drivers/clk/tegra/clk-tegra114.c |   77 ++++++++++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.h          |   32 ++++++++++------
 3 files changed, 130 insertions(+), 39 deletions(-)

-- 
1.7.7.rc0.72.g4b5ea.dirty

