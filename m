Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaELI06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:26:58 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3922 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaELI04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:26:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 12 May 2014 01:22:11 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] ARM: tegra: basic support for NVIDIA SHIELD
Date: Mon, 12 May 2014 17:26:47 +0900
Message-ID: <1399883209-31169-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT for SHIELD, hopefully in time for 3.16.

Almost everything we could enable at this stage is here. Only the DSI
panel is still missing, I could not get it to work without workarounds
for some reason. Will try to fix that and submit a fixup patch.

Without the panel working this DT is not so useful currently, but it
would be great if we could at least validate it and secure it for 3.16,
so panel support could make it during the -rc cycle.

Thanks,
Alex.

Alexandre Courbot (2):
  ARM: tegra: joystick input in tegra_defconfig
  ARM: tegra: add device tree for SHIELD

 arch/arm/boot/dts/Makefile          |    1 +
 arch/arm/boot/dts/tegra114-roth.dts | 1113 +++++++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig    |    1 +
 3 files changed, 1115 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra114-roth.dts

-- 
1.9.2

