Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3AKNNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:13:24 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56486 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab3AKNNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:13:23 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com
Subject: [PATCH 00/18] AB8500 battery management series upgrade
Date: Fri, 11 Jan 2013 13:12:48 +0000
Message-Id: <1357909986-9262-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Here we go again. This patches include your suggested fixups.

Please find the next instalment of the AB8500 Power drivers upgrade.
A lot of work has taken place on the internal development track, but
little effort has gone into mainlining it. At last count there were
around 70+ patches which are in need of forward-porting, then
upstreaming. This patch-set aims to make a good start. :)

 drivers/power/Kconfig                |   15 +
 drivers/power/Makefile               |    1 +
 drivers/power/ab8500_bmdata.c        |   18 +-
 drivers/power/ab8500_btemp.c         |   27 +-
 drivers/power/ab8500_charger.c       |  359 ++++++--
 drivers/power/ab8500_fg.c            |  277 ++++--
 drivers/power/abx500_chargalg.c      |   30 +-
 drivers/power/pm2301_charger.c       | 1599 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/abx500.h           |    6 +-
 include/linux/mfd/abx500/ab8500-bm.h |   10 +
 include/linux/mfd/abx500/ab8500.h    |    5 +
 include/linux/pm2301_charger.h       |   60 ++
 12 files changed, 2259 insertions(+), 148 deletions(-)

