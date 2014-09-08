Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaIHRAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:00:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36333 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbaIHRAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:00:45 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [GIT PULL 1/2] ARM: OMAP 4+: powerdomain fixes
Date: Mon, 8 Sep 2014 12:00:19 -0500
Message-ID: <1410195620-6347-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
Please pull the following changes.
Series discussed in:
http://marc.info/?l=linux-kernel&m=140871554106082&w=2
Includes (v2 patch) https://patchwork.kernel.org/patch/4790541/
Status: Acked by Santosh and Reviewed-by Kevin	

These could go into your tree for the branch omap-for-v3.18/fixes-not-urgent

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  https://github.com/nmenon/linux-2.6-playground.git pull/v3.18/powerdomain-fixes

for you to fetch changes up to 3e6a1c945950140926dd6e2cc667893de0a7fe3b:

  ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug (2014-09-08 11:22:43 -0500)

----------------------------------------------------------------
Nishanth Menon (7):
      ARM: OMAP: DRA7: powerdomain data: fix powerdomain powerstate
      ARM: OMAP5: powerdomain data: fix powerdomain powerstate
      ARM: OMAP2+: powerdomain: pwrdm_for_each_clkdm iterate only valid clkdms
      ARM: OMAP2+: powerdomain: introduce logic for finding valid power domain
      ARM: OMAP4+: PM: Make logic state programmable
      ARM: OMAP4+: PM: use only valid low power state for suspend
      ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug

 arch/arm/mach-omap2/omap-mpuss-lowpower.c   |    4 ++
 arch/arm/mach-omap2/pm44xx.c                |    9 ++-
 arch/arm/mach-omap2/powerdomain.c           |   79 ++++++++++++++++++++++++++-
 arch/arm/mach-omap2/powerdomain.h           |    4 ++
 arch/arm/mach-omap2/powerdomains54xx_data.c |   12 ++--
 arch/arm/mach-omap2/powerdomains7xx_data.c  |   14 ++---
 6 files changed, 106 insertions(+), 16 deletions(-)

Regards,
Nishanth Menon
