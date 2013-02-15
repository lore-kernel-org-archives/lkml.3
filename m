Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161835Ab3BONIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:08:45 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:46802 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161260Ab3BOMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:43 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com
Subject: [PATCH 00/40] Power: AB8500: Internal development push
Date: Fri, 15 Feb 2013 12:44:30 +0000
Message-Id: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

This is the 3rd and final instalment of the push to synchronise
the ABx500 Battery Management series of internal development patches
due for Mainline.

This patch-set submission is for reviewing purposes only. Please
don't apply patches directly from this patch-set, as there are some
interdependencies with another patch-set due for the MFD tree. We
can chat about how to over-come this at a later date.

Enjoy! =:-)

 drivers/mfd/ab8500-core.c                 |   36 +++++++
 drivers/power/Kconfig                     |    7 --
 drivers/power/Makefile                    |    3 +-
 drivers/power/ab8500_bmdata.c             |   96 ++++++++++++++++-
 drivers/power/ab8500_btemp.c              |   75 +++++++++++---
 drivers/power/ab8500_charger.c            |  699 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------
 drivers/power/ab8500_fg.c                 |  449 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/power/abx500_chargalg.c           |  455 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------
 drivers/power/pm2301_charger.c            |  365 +++++++++++++++++++++++++++++++++++++++++++++++-----------------
 drivers/power/pm2301_charger.h            |   23 +----
 include/linux/mfd/abx500.h                |   21 +++-
 include/linux/mfd/abx500/ab8500-bm.h      |   60 ++++++++++-
 include/linux/mfd/abx500/ab8500.h         |   46 +++++++++
 include/linux/mfd/abx500/ux500_chargalg.h |    7 ++
 include/linux/pm2301_charger.h            |    2 +-
 15 files changed, 1842 insertions(+), 502 deletions(-)

