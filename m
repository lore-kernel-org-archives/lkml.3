Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3CPGQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 02:16:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38652 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab3CPGQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 02:16:56 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lokeshvutla@ti.com>
Subject: [PATCH V2 0/8] memory: emif: miscellaneous bug fixes for EMIF driver
Date: Sat, 16 Mar 2013 11:46:40 +0530
Message-ID: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series resolves a few minor issues for EMIF driver.

Tested all patches on OMAP4430-sdp.
Patch : "memory: emif: setup LP settings on freq update"
is tested on a local tree, since freq update cannot be
tested on mainline.

Ambresh K (1):
  memory: emif: setup LP settings on freq update

Grygorii Strashko (1):
  memory: emif: errata i743: Prohibit usage of Power-Down mode

Lokesh Vutla (2):
  memory: emif: Fix the lpmode timeout calculation
  memory: emif: Load the correct custom config values from dt

Nishanth Menon (3):
  memory: emif: handle overflow for timing for LP mode
  memory: emif: Handle devices which are not rated for >85C
  memory: emif: use restart if power_off not present when out of spec

Oleksandr Dmytryshyn (1):
  memory: emif: Fix the incorrect 'size' parameter in memcpy

 drivers/memory/emif.c                   |  129 +++++++++++++++++++++++++++----
 include/linux/platform_data/emif_plat.h |    1 +
 2 files changed, 114 insertions(+), 16 deletions(-)

-- 
1.7.9.5

