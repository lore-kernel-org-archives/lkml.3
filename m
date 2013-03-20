Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab3CTNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:47:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9937 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CTNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:47:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Mar 2013 06:47:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/4] ARM: tegra: dalmore: add regulators
Date: Wed, 20 Mar 2013 19:14:26 +0530
Message-ID: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (4):
  ARM: tegra: enable Tegra114 based platform PMICs
  ARM: tegra: dalmore: add cpu regulator's node
  ARM: tegra: dalmore: add dt node for TPS65090's regulators
  ARM: tegra: dalmore: add fixed regulator's node

 .../devicetree/bindings/regulator/tps65090.txt     |    4 +-
 arch/arm/boot/dts/tegra114-dalmore.dts             |  160 ++++++++++++++++++++
 arch/arm/configs/tegra_defconfig                   |    7 +
 3 files changed, 169 insertions(+), 2 deletions(-)

