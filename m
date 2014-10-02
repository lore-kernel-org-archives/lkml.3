Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaJBHxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:53:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44886 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaJBHxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:53:44 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        <kernel-janitors@vger.kernel.org>
CC: <dan.carpenter@oracle.com>, <detheridge@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 0/2] Couple of changes to gpio-gate-clock
Date: Thu, 2 Oct 2014 10:53:30 +0300
Message-ID: <cover.1412234778.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first was suggested by Dan Carpenter. The second is just cleaning
and not affecting the functionality.

Jyri Sarha (2):
  clk: gpio-gate: Stop using devres API
  clk: gpio-gate: Rename the struct from clk_gpio to clk_gpio_gate

 drivers/clk/clk-gpio-gate.c  |   34 ++++++++++++----------------------
 include/linux/clk-provider.h |    2 +-
 2 files changed, 13 insertions(+), 23 deletions(-)

-- 
1.7.9.5

