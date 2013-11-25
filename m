Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3KYVpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:45:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50891 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab3KYVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:45:32 -0500
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 0/7] AES/DES hwmod data and dmtimer fix
Date: Mon, 25 Nov 2013 15:44:29 -0600
Message-ID: <1385415876-12387-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are patches adding hwmod for AES/DES crypto modules for OMAP4, DRA7 SoCs.

Also included is a fix that disables POSTED mode when dmtimer is requested.

Joel Fernandes (7):
  ARM: OMAP: hwmod: Add SYSC offsets for AES IP
  ARM: DRA7xx: hwmod: Add hwmod data for DES IP
  ARM: DRA7xx: hwmod: Add hwmod data for AES IP
  ARM: OMAP4: hwmod: Add hwmod data for AES IP
  ARM: OMAP4: hwmod: add hwmod data for DES IP
  ARM: OMAP: Disable POSTED mode for errata i103 and i767
  OMAP: AM33xx: hwmod: Correct AES module SYSC type

 arch/arm/mach-omap2/omap_hwmod.h                   |  11 +++
 .../mach-omap2/omap_hwmod_33xx_43xx_ipblock_data.c |   1 +
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         | 101 +++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |  78 ++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |  10 ++
 arch/arm/plat-omap/include/plat/dmtimer.h          |   5 +-
 6 files changed, 205 insertions(+), 1 deletion(-)

-- 
1.8.1.2

