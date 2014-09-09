Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaIIERV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:17:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50098 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaIIERS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:17:18 -0400
From: George Cherian <george.cherian@ti.com>
To: <cw00.choi@samsung.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <myungjoo.ham@samsung.com>,
        <grant.likely@linaro.org>, <rongjun.ying@csr.com>,
        <linux@roeck-us.net>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 0/5] Add dt support for extcon gpio driver
Date: Tue, 9 Sep 2014 09:44:33 +0530
Message-ID: <1410236078-11713-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series
        - Convert extcon-gpio driver to use gpiod_* API's
        - Adds dt support to extcon-gpio driver.
	- Add cable name support in case of dt.

George Cherian (5):
  extcon: gpio: Minor cleanups
  extcon: gpio: Convert the driver to use gpio desc API's
  extcon: gpio: Add dt support for the driver.
  extcon: gpio: Always use  gpio_get_value_cansleep
  extcon: gpio: Add support for using cable names

 .../devicetree/bindings/extcon/extcon-gpio.txt     |  23 +++++
 drivers/extcon/extcon-gpio.c                       | 100 +++++++++++++--------
 include/linux/extcon/extcon-gpio.h                 |   4 +-
 3 files changed, 89 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

-- 
1.8.3.1

