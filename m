Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab3LDLfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:35:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50920 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3LDLfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:35:02 -0500
From: Roger Quadros <rogerq@ti.com>
To: <linus.walleij@linaro.org>
CC: <tony@atomide.com>, <peter.ujfalusi@ti.com>, <nm@ti.com>,
        <tomi.valkeinen@ti.com>, <balbi@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/1] gpio: twl4030: gpio LED regression fix for 3.13 rc
Date: Wed, 4 Dec 2013 13:34:30 +0200
Message-ID: <1386156871-7639-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 0b2aa8be that went into 3.13-rc2 introduced a regression
that causes failure in setting LED GPO direction to OUT.

This causes USB Host to fail probe on Beagleboard.

The following patch fixes this issue.

I've tried to higlight the issue in the original patch here
http://www.spinics.net/lists/linux-omap/msg100858.html

cheers,
-roger

Roger Quadros (1):
  gpio: twl4030: Fix regression for twl gpio LED output

 drivers/gpio/gpio-twl4030.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
1.8.3.2

