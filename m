Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3BEKdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:33:31 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:53638 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751511Ab3BEKda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:33:30 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: [PATCH 0/2] gpio: Fix gpio-generic bug and add driver for GRGPIO cores
Date: Tue,  5 Feb 2013 11:33:01 +0100
Message-Id: <1360060383-16880-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second patch is v2 of the earlier single GRGPIO patch

Andreas Larsson (2):
  gpio: gpio-generic: Fix bug in big endian bit conversion
  gpio: Add device driver for GRGPIO cores

 drivers/gpio/Kconfig        |    8 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpio-generic.c |    5 +-
 drivers/gpio/gpio-grgpio.c  |  244 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 257 insertions(+), 1 deletions(-)
 create mode 100644 drivers/gpio/gpio-grgpio.c

