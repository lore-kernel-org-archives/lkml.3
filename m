Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbbARLjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 06:39:53 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:60346 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbbARLjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 06:39:52 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH 0/8] Use of_mm_gpiochip_remove
Date: Sun, 18 Jan 2015 12:39:25 +0100
Message-Id: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
counterpart for of_mm_gpiochip_add.

This set of patches implements the removing of all the drivers that
made use of of_mm_gpiochip_add.

Also some minor cleanups are done on those drivers.

Suggested-by: Linus Walleij <linus.walleij@linaro.org>

Ricardo Ribalda Delgado (8):
  gpio/mpc5200: Use of_mm_gpiochip_remove
  gpio/-mm-lantiq: Use devm_kzalloc
  gpio/mm-lantiq: Do not replicate code
  gpio-mm-lantiq: Use of_propery_read_u16
  gpio/gpio-mm-lantiq: Use of_mm_gpiochip_remove
  gpio/zevio: Use of_mm_gpiochip_remove
  gpio/mpc8xxx: Convert to platform device interface.
  gpio/mpc8xxx: Use of_mm_gpiochip_remove

 drivers/gpio/gpio-mm-lantiq.c | 41 ++++++++++++++-----------
 drivers/gpio/gpio-mpc5200.c   | 23 ++++++++++----
 drivers/gpio/gpio-mpc8xxx.c   | 70 ++++++++++++++++++++++++++-----------------
 drivers/gpio/gpio-zevio.c     | 12 ++++++++
 4 files changed, 95 insertions(+), 51 deletions(-)

-- 
2.1.4

