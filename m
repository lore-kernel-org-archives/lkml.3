Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab3CUNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:50:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11038 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3CUNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:50:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Mar 2013 06:50:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] ARM: tegra: dalmore: add regulators
Date: Thu, 21 Mar 2013 19:17:39 +0530
Message-ID: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add the regulators for Dalmore platform.
Dalmore also have the Palma PMIC as primary PMIC but 
dt population will be send later once DT documentation
finalize.

Changes from V1:
- Rearrange patches so that config change will be last patch.
- Correct some sentence and Caps.
- fix compilation issue arise in mid of patches.

Laxman Dewangan (4):
  ARM: tegra: dalmore: add cpu regulator node
  ARM: tegra: dalmore: add TPS65090 node
  ARM: tegra: dalmore: add fixed regulator node
  ARM: tegra: enable Tegra114 based platform PMICs

 arch/arm/boot/dts/tegra114-dalmore.dts |  162 ++++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig       |    7 ++
 2 files changed, 169 insertions(+), 0 deletions(-)

