Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaBYKEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:04:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37101 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaBYKEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:02 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 0/2] regulator: core: always_on fixups
Date: Tue, 25 Feb 2014 11:03:45 +0100
Message-Id: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The second patch adds a check for dummy regulators that are not always_on. The
first patch adds a always_on constraint to the dummy regulator.

Regards,

Markus


Markus Pargmann (2):
  regulator: dummy: Should be always-on
  regulator: core: Error on not always_on dummy regulators

 drivers/regulator/core.c  | 27 ++++++++++++++++++++++++---
 drivers/regulator/dummy.c |  6 +++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

-- 
1.8.5.3

