Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809Ab3LFMVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:21:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab3LFMVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:21:25 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 0/3] PHY: Fixes for 3.13-rc
Date: Fri, 6 Dec 2013 17:51:17 +0530
Message-ID: <1386332480-31671-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
We have three patches to be merged in PHY subsystem for this rc cycle and
all of them are critical.

One fixes a memory leak, the other solves a NULL dereference while calling
dev_WARN and the last one fixes a randconfig error.

Let me know if I have to change anything.

I've also queued these fixes in
https://git.kernel.org/cgit/linux/kernel/git/kishon/linux-phy.git/ fixes
(contains patches to be merged in other trees too).

Dan Carpenter (1):
  drivers: phy: tweaks to phy_create()

Kishon Vijay Abraham I (1):
  phy: kconfig: add depends on "USB_PHY" to OMAP_USB2 and TWL4030_USB

Sachin Kamat (1):
  drivers: phy: Fix memory leak

 drivers/phy/Kconfig    |    4 ++--
 drivers/phy/phy-core.c |   26 ++++++++++----------------
 2 files changed, 12 insertions(+), 18 deletions(-)

-- 
1.7.10.4

