Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaKCQdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:33:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43753 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaKCQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:33:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@ti.com>,
        <grant.likely@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 0/4] extcon: gpio: add DT support
Date: Mon, 3 Nov 2014 10:32:26 -0600
Message-ID: <1415032350-8459-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series has been tested with v3.18-rc2 with a
yet-to-be-released board (called X15). That board
is DT-only and we use extcon-gpio to decide which
USB mode should be used (host or peripheral).

George Cherian (4):
  extcon: gpio: Convert the driver to use gpio desc API's
  extcon: gpio: Add dt support for the driver.
  extcon: gpio: Always use gpio_get_value_cansleep
  extcon: gpio: Add support for using cable names

 .../devicetree/bindings/extcon/extcon-gpio.txt     | 23 ++++++
 drivers/extcon/extcon-gpio.c                       | 93 ++++++++++++++--------
 2 files changed, 84 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt

-- 
2.1.0.GIT

