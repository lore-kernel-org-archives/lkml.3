Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaHVNzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:55:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43531 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbaHVNyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:10 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/6] ARM: OMAP3+: PRM: fix up prm_handling
Date: Fri, 22 Aug 2014 08:51:47 -0500
Message-ID: <1408715513-25851-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series are various fixes and improvements for
PRM for I/O Daisy chain support in OMAP4+ with device tree.

This is part 2/6 series which eventually enables framework for
suspend-to-ram and cpuidle for OMAP5 and DRA7

Each of series is based on v3.17-rc1 and this specific series is available:
weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/prm-fixes

git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/prm-fixes

An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework


Nishanth Menon (6):
  ARM: OMAP4+: prminst: provide function to find prm_dev instance
    offset
  ARM: OMAP4: PRM: use the generic prm_inst to allow logic to be
    abstracted
  ARM: OMAP4+: PRM: register interrupt information from DT
  ARM: OMAP4+: PRM: remove "wkup" event
  ARM: OMAP4+: PRM: Enable wakeup capability for OMAP5, DRA7
  ARM: OMAP3+: PRM: register interrupt information from DT

 arch/arm/mach-omap2/prm3xxx.c     |   18 ++++++++
 arch/arm/mach-omap2/prm44xx.c     |   90 ++++++++++++++++++++++++++++++++-----
 arch/arm/mach-omap2/prminst44xx.c |   40 ++++++++++-------
 arch/arm/mach-omap2/prminst44xx.h |    3 ++
 4 files changed, 125 insertions(+), 26 deletions(-)

-- 
1.7.9.5

