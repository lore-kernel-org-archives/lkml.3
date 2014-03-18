Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaCRO4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:56:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaCRO4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:56:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Sekhar Nori <nsekhar@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 0/3] Remove obsolete tnetv107x drivers
Date: Tue, 18 Mar 2014 15:55:58 +0100
Message-Id: <1395154561-1199121-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:IoY5jFrSMlemAvIPQa2vvjTST4xbuRIYORqfO2/0FyX
 Bz+9d2N/Pq9RtsIV1tpwUowL6LV8znuTHWyyo7/L7oZf2kF8PZ
 CuwongSSp5MYO9VsyfbDa6yFUrsy9/BrQQPaAO0aQa+pmhjXLW
 hvWWeiWMjGfBkgen9MrMqr/GoH63urknGUL9rE+W0cjBtVFFrM
 CB9AqG2VXTTgMNIBQ6zOfcDpAlP2RH9pNdvLMkkG8f0zjdZm3S
 pQoYIiQgj0OfquKEarOac4xhEFo8STd4LurfHwyuBeWkgB7Wqm
 vgoTK6sv8/icKaXMJFSGRevPFzHePBkqJsNNgQMe27wE8WkIQT
 vOL5TyI5bXtbRPsLWnTamFlSyACbPhzeRVmf1V2HY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have applied the platform removal patch with the Ack
from Kevin and Sekhar. Please apply these other patches
through the input/mfd/spi trees.

Arnd Bergmann (3):
  spi: remove obsolete spi-ti-ssp driver
  mfd: remove obsolete ti-ssp driver
  input: remove obsolete tnetv107x drivers

 drivers/input/keyboard/Kconfig            |  10 -
 drivers/input/keyboard/Makefile           |   1 -
 drivers/input/keyboard/tnetv107x-keypad.c | 329 ---------------------
 drivers/input/touchscreen/Kconfig         |   9 -
 drivers/input/touchscreen/Makefile        |   1 -
 drivers/input/touchscreen/tnetv107x-ts.c  | 384 ------------------------
 drivers/mfd/Kconfig                       |  11 -
 drivers/mfd/Makefile                      |   1 -
 drivers/mfd/ti-ssp.c                      | 465 ------------------------------
 drivers/spi/Kconfig                       |   7 -
 drivers/spi/Makefile                      |   1 -
 drivers/spi/spi-ti-ssp.c                  | 378 ------------------------
 12 files changed, 1597 deletions(-)
 delete mode 100644 drivers/input/keyboard/tnetv107x-keypad.c
 delete mode 100644 drivers/input/touchscreen/tnetv107x-ts.c
 delete mode 100644 drivers/mfd/ti-ssp.c
 delete mode 100644 drivers/spi/spi-ti-ssp.c

Cc: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org

-- 
1.8.3.2

