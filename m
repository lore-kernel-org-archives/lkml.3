Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab3AaTYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:24:54 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56616 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3AaTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:24:52 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ARM: OMAP2+: Export SoC information to userspace using SoC infrastructure
Date: Thu, 31 Jan 2013 21:24:42 +0200
Message-Id: <1359660284-5225-1-git-send-email-ruslan.bilovol@ti.com>
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

Ruslan Bilovol (2):
  ARM: OMAP2+: SoC name and revision unification
  ARM: OMAP2+: Export SoC information to userspace

 arch/arm/mach-omap2/Kconfig  |    1 +
 arch/arm/mach-omap2/common.h |    8 +++
 arch/arm/mach-omap2/id.c     |  152 ++++++++++++++++++++++++++++++++----------
 arch/arm/mach-omap2/io.c     |    1 +
 4 files changed, 125 insertions(+), 37 deletions(-)

-- 
1.7.9.5

