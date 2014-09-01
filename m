Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaIAMyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:54:03 -0400
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:49855 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaIAMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:53:58 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@avagotech.com>
Subject: [PATCH 0/2] Add driver for AXM55xx SSP chip selects
Date: Mon,  1 Sep 2014 14:53:39 +0200
Message-Id: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver enables control of the SSP/SPI chip-select signals as GPIOs on the
AXM55xx device.

Anders Berg (2):
  gpio: Add driver for AXM55xx SSP chip selects
  Documentation: DT bindings for AXM55xx SSP CS

 .../devicetree/bindings/gpio/gpio-axxia-sspcs.txt  |  36 ++++++
 drivers/gpio/Kconfig                               |   8 ++
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-axxia-ssp.c                      | 128 +++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-axxia-sspcs.txt
 create mode 100644 drivers/gpio/gpio-axxia-ssp.c

-- 
1.9.1

