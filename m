Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbaKYPrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:47:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50462 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaKYPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:47:11 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 0/5] hwmon: ina2xx: fixes & extensions
Date: Tue, 25 Nov 2014 16:46:58 +0100
Message-Id: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches fixes an initialization issue we've experienced with the
ina2xx driver and extends the sysfs interface to make the driver configurable
at run-time.

Bartosz Golaszewski (5):
  hwmon: ina2xx: bail-out from ina2xx_probe() in case of configuration errors
  hwmon: ina2xx: make shunt resistance configurable at run-time
  hwmon: ina2xx: allow to change the averaging rate at run-time
  hwmon: ina2xx: change hex constants to lower-case
  hwmon: ina2xx: documentation update for new sysfs attributes

 Documentation/hwmon/ina2xx |  10 ++-
 drivers/hwmon/ina2xx.c     | 204 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 198 insertions(+), 16 deletions(-)

-- 
2.1.3

