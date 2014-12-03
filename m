Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaLCNGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:06:36 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:48846 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaLCNGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:06:35 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v4 0/3] hwmon: ina2xx: new attributes
Date: Wed,  3 Dec 2014 14:06:08 +0100
Message-Id: <1417611971-10360-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series extends the sysfs interface to make the driver configurable
at run-time.

The shunt_resistor attribute allows to change the shunt resistance value
at run-time in cases where ina2xx used to do the measurement isn't integrated
with the shunt.

The avg_rate attribute allows to increase/decrease noise reduction.

v4:
- corrected the wrong e-mail address in the Signed-off-by field

v3:
- avg_rate is now only created for ina226
- avg_rate displays available averaging rates on read
- other minor fixes according to the code review

v2: https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg776942.html

The following patches have been rebased against the hwmon-next branch.

Bartosz Golaszewski (3):
  hwmon: ina2xx: make shunt resistance configurable at run-time
  hwmon: ina2xx: allow to change the averaging rate at run-time
  hwmon: ina2xx: documentation update for new sysfs attributes

 Documentation/hwmon/ina2xx |  10 ++-
 drivers/hwmon/ina2xx.c     | 195 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 190 insertions(+), 15 deletions(-)

-- 
2.1.3

