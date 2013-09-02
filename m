Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab3IBCak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:30:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42441 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3IBCaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:30:39 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 0/3] cleanup of gpio_pcf857x.c 
Date: Mon, 2 Sep 2013 08:00:01 +0530
Message-ID: <1378089004-14478-1-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series
        - removes the irq_demux_work
        - Uses devm_request_threaded_irq
        - Call the user handler iff gpio_to_irq is done.

v1 --> v2
        Split v1 to 3 patches
v2 --> v3
	Remove the unnecessary dts patches.


George Cherian (3):
  gpio: pcf857x: change to devm_request_threaded_irq
  gpio: pcf857x: remove the irq_demux_work
  gpio: pcf857x: call the gpio user handler iff gpio_to_irq is done

 drivers/gpio/gpio-pcf857x.c | 51 +++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

-- 
1.8.1.4

