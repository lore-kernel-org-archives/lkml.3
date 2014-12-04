Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaLDJ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:58:00 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:32942 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbaLDJ54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:57:56 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 0/2] hwmon: tmp401: support for TMP435 and fix for a probe issue
Date: Thu,  4 Dec 2014 10:57:26 +0100
Message-Id: <1417687048-21455-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the TI TMP435 chip and fixes an issue similar
to the one we observed for ina2xx - ignoring the write errors when probing the
device.

Bartosz Golaszewski (1):
  hwmon: tmp401: bail-out from tmp401_probe() in case of write errors

Patrick Titiano (1):
  hwmon: tmp401: add support for TI TMP435

 drivers/hwmon/tmp401.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

-- 
2.1.3

