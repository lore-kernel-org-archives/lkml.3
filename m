Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3H1Psx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:48:53 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19836 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3H1Psw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:48:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Aug 2013 08:48:51 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 0/6] HDMI support for Tegra114 Dalmore
Date: Wed, 28 Aug 2013 18:48:36 +0300
Message-ID: <1377704922-2824-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds HDMI support for the Tegra114 Dalmore board.
Tested with 1080p DVI and HDMI monitors.

Mikko Perttunen (6):
  host1x: hdmi: Add Tegra114 support
  host1x: hdmi: Detect whether display is connected with HDMI or DVI
  host1x: hdmi: Enable Vdd earlier for hotplug/DDC
  clk: tegra114: Initialize clocks needed for HDMI
  ARM: tegra: Add host1x, DC and HDMI to Tegra114 device tree
  ARM: tegra: Add HDMI to Tegra114 Dalmore device tree

 arch/arm/boot/dts/tegra114-dalmore.dts |  17 ++++
 arch/arm/boot/dts/tegra114.dtsi        |  42 +++++++++
 drivers/clk/tegra/clk-tegra114.c       |   3 +
 drivers/gpu/host1x/dev.c               |   1 +
 drivers/gpu/host1x/drm/drm.c           |   1 +
 drivers/gpu/host1x/drm/hdmi.c          | 125 ++++++++++++++++++++++++---
 drivers/gpu/host1x/drm/hdmi.h          | 152 +++++++++++++++++++++++++++++++++
 7 files changed, 331 insertions(+), 10 deletions(-)

-- 
1.8.1.5

