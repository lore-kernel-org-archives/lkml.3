Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbALNri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:47:38 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33318 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbALNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:47:36 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 0/2] hwmon: (ina2xx) code clean-up and minor fixes
Date: Mon, 12 Jan 2015 14:47:20 +0100
Message-Id: <1421070442-9635-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series fixes two minor issues in the driver after recent
implementation of new attributes. The first patch removes an unnecessary
result check after calling dev_get_drvdata() and the second one adds
calls to DIV_ROUND_CLOSEST() to avoid rounding errors.

This series is rebased against current hwmon-next.

Bartosz Golaszewski (2):
  hwmon: (ina2xx) remove an unnecessary dev_get_drvdata() result check
  hwmon: (ina2xx) use DIV_ROUND_CLOSEST() to avoid rounding errors

 drivers/hwmon/ina2xx.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.1.3

