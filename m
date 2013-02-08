Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203Ab3BHPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:43:49 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50959 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760159Ab3BHPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:43:46 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: andi@etezian.org, tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Date: Fri,  8 Feb 2013 17:43:39 +0200
Message-Id: <1360338220-12753-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch adds support for TC358765 DSI-to-LVDS transmitter
from Toshiba, that is used in OMAP4 Blaze Tablet development
platform. It was originally developed a long time ago and
was used internally survived few kernel migrations.
Different people worked in this driver during last two
years changing its sources to what each new version of
kernel expects.

Current version is ported from internal kernel v3.4 to 3.8.0-rc6
Tested basic functioning under busybox.

------------------------------------------------
v2:
- added returns of correct errno instead of magic numbers
- used delays, based on hrtimers where possible
- fixed typo
- switched to devres management of resources instead of raw
  calls


Tomi Valkeinen (1):
  OMAP4: DSS: Add panel for Blaze Tablet boards

 drivers/video/omap2/displays/Kconfig          |   15 +
 drivers/video/omap2/displays/Makefile         |    1 +
 drivers/video/omap2/displays/panel-tc358765.c | 1000 +++++++++++++++++++++++++
 drivers/video/omap2/displays/panel-tc358765.h |  170 +++++
 include/video/omap-panel-tc358765.h           |   53 ++
 5 files changed, 1239 insertions(+)
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.c
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.h
 create mode 100644 include/video/omap-panel-tc358765.h

-- 
1.7.9.5

