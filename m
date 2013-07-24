Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3GXQfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:35:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56484 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab3GXQfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:35:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: [PATCH 0/2] Add Dialog DA9063 core and regulator drivers
Date: Wed, 24 Jul 2013 18:34:41 +0200
Message-Id: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I've taken the DA9063 patches posted by Krystian Garbaciak last year and
tried to massage them into shape a bit, added device tree support and  
made changes to use more of the existing regulator and regmap infrastructure.
Here are the core driver and the regulator driver. 

The core driver depends on a patch I've sent earlier:
"[RFC] regmap: core: allow a virtual range to cover its own data window"
(https://lkml.org/lkml/2013/7/23/165). 

regards
Philipp

 drivers/mfd/Kconfig                  |   12 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9063-core.c            |  177 ++++++
 drivers/mfd/da9063-i2c.c             |  197 ++++++
 drivers/mfd/da9063-irq.c             |  193 ++++++
 drivers/regulator/Kconfig            |   10 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9063-regulator.c | 1042 ++++++++++++++++++++++++++++++++
 include/linux/mfd/da9063/core.h      |  110 ++++
 include/linux/mfd/da9063/pdata.h     |  114 ++++
 include/linux/mfd/da9063/registers.h | 1090 ++++++++++++++++++++++++++++++++++
 11 files changed, 2949 insertions(+)

