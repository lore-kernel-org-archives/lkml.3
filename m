Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaGUJmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:42:55 -0400
Received: from sauhun.de ([89.238.76.85]:45250 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbaGUJmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:42:54 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 0/2] use correct type for dma_map/unmap
Date: Mon, 21 Jul 2014 11:42:02 +0200
Message-Id: <1405935725-10457-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently stumbled over the fact that the Atmel I2C driver used a wrong enum
for mapping dma, so I wrote a hackish coccinelle script to check the rest of the
kernel. Luckily, only those two were found.

Wolfram Sang (2):
  drivers/i2c/busses: use correct type for dma_map/unmap
  drivers/tty/serial: use correct type for dma_map/unmap

 drivers/i2c/busses/i2c-at91.c     | 4 ++--
 drivers/tty/serial/atmel_serial.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.0.0

