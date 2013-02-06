Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3BFTAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:00:07 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53136 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3BFTAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:00:05 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ARM: OMAP2+: Export SoC information to userspace using SoC infrastructure
Date: Wed,  6 Feb 2013 20:59:54 +0200
Message-Id: <1360177196-18196-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is an attempt to export some OMAP SoC
information (like name, revision etc.) to userspace.
The first patch does some unification of OMAP SoC
information representation in current sources.
Second patch adds exactly needed changes using
exists in Linux kernel SoC infrastructure.

-----------------------------------------
v2:
- changed cpu_* -> soc_* variable names
- rebased on top of 'omap-for-v3.9/soc' branch of tmlind/linux-omap tree

Ruslan Bilovol (2):
  ARM: OMAP2+: SoC name and revision unification
  ARM: OMAP2+: Export SoC information to userspace

 arch/arm/mach-omap2/common.h |    8 +++
 arch/arm/mach-omap2/id.c     |  154 +++++++++++++++++++++++++++++++-----------
 arch/arm/mach-omap2/io.c     |    1 +
 arch/arm/plat-omap/Kconfig   |    1 +
 4 files changed, 126 insertions(+), 38 deletions(-)

-- 
1.7.9.5

