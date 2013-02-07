Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132Ab3BGOk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:40:59 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65480 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3BGOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:40:56 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 0/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Date: Thu,  7 Feb 2013 16:40:49 +0200
Message-Id: <1360248051-16541-1-git-send-email-ruslan.bilovol@ti.com>
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

-
Ruslan

Tomi Valkeinen (1):
  OMAP4: DSS: Add panel for Blaze Tablet boards

 drivers/video/omap2/displays/Kconfig          |   15 +
 drivers/video/omap2/displays/Makefile         |    1 +
 drivers/video/omap2/displays/panel-tc358765.c | 1001 +++++++++++++++++++++++++
 drivers/video/omap2/displays/panel-tc358765.h |  170 +++++
 include/video/omap-panel-tc358765.h           |   53 ++
 5 files changed, 1240 insertions(+)
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.c
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.h
 create mode 100644 include/video/omap-panel-tc358765.h

-- 
1.7.9.5

