Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3AUMET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:19 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:61486 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab3AUMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:17 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru
Subject: [PATCH 00/24] Power: Next batch of AB8500 Battery Management patches 
Date: Mon, 21 Jan 2013 12:03:36 +0000
Message-Id: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Standard bumph:
Please find the next instalment of the AB8500 Power drivers upgrade.
A lot of work has taken place on the internal development track, but
little effort has gone into mainlining it. There is a large backlog
of patches which are in need of forward-porting, then upstreaming.
This patch-set aims to make a large dent into them.

I know that there are some formatting misdemeanours within the code,
but in an attempt to minimise the risk of future merge conflicts I'd
rather address them once everything has been applied. I hope you
understand the method behind the madness.

Kind regards,
Lee

 drivers/mfd/ab8500-core.c                 |    6 +
 drivers/power/Kconfig                     |   26 +
 drivers/power/Makefile                    |    3 +
 drivers/power/ab8500_btemp.c              |   67 +-
 drivers/power/ab8500_charger.c            |  629 ++++++++---
 drivers/power/ab8500_fg.c                 |  316 ++----
 drivers/power/ab8500_fg.h                 |  244 +++++
 drivers/power/ab8500_fg_deepdebug.c       | 1692 +++++++++++++++++++++++++++++
 drivers/power/abx500_chargalg.c           |   43 +-
 drivers/power/pm2301_charger.c            | 1097 +++++++++++++++++++
 drivers/power/pm2301_charger.h            |  535 +++++++++
 drivers/power/pm2301_deepdebug.c          |  131 +++
 include/linux/mfd/abx500.h                |    3 +
 include/linux/mfd/abx500/ab8500-bm.h      |  186 +++-
 include/linux/mfd/abx500/ab8500.h         |   19 +
 include/linux/mfd/abx500/ux500_chargalg.h |    5 +
 include/linux/pm2301_charger.h            |   61 ++
 17 files changed, 4655 insertions(+), 408 deletions(-)

