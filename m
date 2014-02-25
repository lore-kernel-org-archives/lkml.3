Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaBYWRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:17:50 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:59557 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBYWRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:17:49 -0500
X-IronPort-AV: E=Sophos;i="4.97,542,1389772800"; 
   d="scan'208";a="16790641"
From: Markus Mayer <markus.mayer@linaro.org>
To: Matt Porter <matt.porter@linaro.org>, Christian Daudt <bcm@fixthebug.org>
CC: ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] ARM: bcm281xx: Consolidate code
Date: Tue, 25 Feb 2014 14:17:42 -0800
Message-ID: <1393366666-28625-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains some code consolidation for the Broadcom BCM281xx
family of SoCs.

- Move kona_l2_cache_init() so other platforms can reuse it
- Consolidate reboot code and move it to the board specific file
- Sort header files in board file alphabetically
- Rename the board_init() function to be board specific

Markus Mayer (4):
  ARM: bcm281xx: Move kona_l2_cache_init() so it can be shared
  ARM: bcm281xx: Consolidate reboot code
  ARM: bcm281xx: Re-order hearder files
  ARM: bcm281xx: Rename board_init() function

 arch/arm/mach-bcm/board_bcm281xx.c |   74 ++++++++++++++++++------------------
 arch/arm/mach-bcm/kona.c           |   64 ++++++++++---------------------
 arch/arm/mach-bcm/kona.h           |    7 +---
 3 files changed, 59 insertions(+), 86 deletions(-)

-- 
1.7.9.5

