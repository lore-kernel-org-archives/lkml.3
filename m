Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3IVTwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:52:05 -0400
Received: from svenfoo.org ([82.94.215.22]:59110 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3IVTv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:51:58 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, devicetree@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 0/4] dac7512: some cleanups and DT bindings
Date: Sun, 22 Sep 2013 21:51:45 +0200
Message-Id: <1379879509-3608-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some trivial things for the ti_dac7512 driver.

Mark, can you take them through your spi tree?


Thanks,
Daniel

Daniel Mack (4):
  drivers: misc: ti_dac7512: drop module version
  drivers: misc: ti_dac7512: drop DAC7512_DRV_NAME
  drivers: misc: ti_dac7512: provide a SPI ID table
  drivers: misc: ti_dac7512: add support for DT matching

 .../devicetree/bindings/misc/ti,dac7512.txt        | 20 +++++++++++++++++++
 drivers/misc/ti_dac7512.c                          | 23 +++++++++++++++++-----
 2 files changed, 38 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/misc/ti,dac7512.txt

-- 
1.8.3.1

