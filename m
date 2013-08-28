Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3H1KlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:41:22 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10301 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3H1KlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:41:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 03:38:48 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 0/5] HDMI support for Tegra114 Dalmore
Date: Wed, 28 Aug 2013 13:40:54 +0300
Message-ID: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds HDMI support for the Tegra114 Dalmore board.
Tested with 1080p DVI and HDMI monitors.

Mikko Perttunen (5):
  host1x: hdmi: Add Tegra114 support
  host1x: hdmi: Detect whether display is connected with HDMI or DVI
  clk: tegra114: Initialize clocks needed for HDMI
  ARM: tegra: Add host1x, dc and hdmi to Tegra114 device tree
  ARM: tegra: Add hdmi to Tegra114 Dalmore device tree

 arch/arm/boot/dts/tegra114-dalmore.dts |  17 ++++
 arch/arm/boot/dts/tegra114.dtsi        |  43 ++++++++++
 drivers/clk/tegra/clk-tegra114.c       |   3 +
 drivers/gpu/host1x/drm/drm.c           |   1 +
 drivers/gpu/host1x/drm/hdmi.c          | 110 +++++++++++++++++++++++-
 drivers/gpu/host1x/drm/hdmi.h          | 152 +++++++++++++++++++++++++++++++++
 6 files changed, 323 insertions(+), 3 deletions(-)

-- 
1.8.1.5

