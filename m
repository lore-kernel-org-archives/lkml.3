Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaAFV4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:56:30 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:65287 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaAFV43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:56:29 -0500
X-IronPort-AV: E=Sophos;i="4.95,614,1384329600"; 
   d="scan'208";a="7940059"
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH v2 0/2] watchdog: bcm281xx: Debugfs support
Date: Mon, 6 Jan 2014 13:56:09 -0800
Message-ID: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds debugfs support to the bcm281xx watchdog driver. Most
of the code submitted here was already included as part of v5 of the
original driver submission. See
http://www.spinics.net/lists/linux-watchdog/msg03328.html

This series is dependent on commit
bd90ccd42c5d6317979c62919ba1c79fd34fa785 in linux-watchdog-next.

Changes since v1 of this series:

- http://www.spinics.net/lists/linux-watchdog/msg03544.html has been
  included here

- bcm_kona_wdt_debug_init() and bcm_kona_wdt_debugfs_init() as well as
  bcm_kona_wdt_debug_exit() and bcm_kona_debugfs_exit() were merged
  together, so now there are just two instead of four functions 

Markus Mayer (2):
  watchdog: bcm281xx: Debugfs support
  watchdog: bcm281xx: Turn on debugfs support for watchdog driver

 arch/arm/configs/bcm_defconfig  |    1 +
 drivers/watchdog/Kconfig        |   10 ++++
 drivers/watchdog/bcm_kona_wdt.c |  108 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 115 insertions(+), 4 deletions(-)

-- 
1.7.9.5

