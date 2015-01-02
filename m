Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbbABRSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 12:18:35 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:38269 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbbABRSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 12:18:32 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Santosh <ssantosh@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] ARM: l2c: OMAP4/AM437x: Additional register programming support.
Date: Fri, 2 Jan 2015 11:17:50 -0600
Message-ID: <1420219072-6521-1-git-send-email-nm@ti.com>
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

This provides some support to the series: http://marc.info/?l=linux-arm-kernel&m=141933190912495&w=2

Nishanth Menon (2):
  ARM: l2c: OMAP4/AM437x: Introduce support for cache latency
    programming
  ARM: l2c: AM437x: Introduce support for cache filter programming

 arch/arm/mach-omap2/common.h       |    1 +
 arch/arm/mach-omap2/omap-secure.h  |    2 ++
 arch/arm/mach-omap2/omap-smc.S     |   20 ++++++++++++++++++++
 arch/arm/mach-omap2/omap4-common.c |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)

Regards,
Nishanth Menon

-- 
1.7.9.5

