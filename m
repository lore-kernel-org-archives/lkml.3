Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbbABRo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:44:26 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39060 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbABRoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:44:25 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] ARM: l2c: OMAP4/AM437x: Additional register programming support.
Date: Fri, 2 Jan 2015 11:43:46 -0600
Message-ID: <1420220628-23742-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
OMAP4 and AM437x ROM code provides services to program PL310's latency
registers and AM437x provides service for programming Address filter
registers.

Provide support in the kernel for the same.

V2 of the series contains documentation update and a bug fix due to a
typo introduced during patch split :(

Nishanth Menon (2):
  ARM: l2c: OMAP4/AM437x: Introduce support for cache latency
    programming
  ARM: l2c: AM437x: Introduce support for cache filter programming

 arch/arm/mach-omap2/common.h       |    1 +
 arch/arm/mach-omap2/omap-secure.h  |    2 ++
 arch/arm/mach-omap2/omap-smc.S     |   20 ++++++++++++++++++++
 arch/arm/mach-omap2/omap4-common.c |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)

-- 
1.7.9.5

