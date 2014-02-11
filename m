Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaBKTuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:50:17 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39058 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaBKTuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:50:08 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v2 0/2] of/gpio: Automatic handling of devicetree open-drain GPIO specifications.
Date: Tue, 11 Feb 2014 11:49:58 -0800
Message-Id: <1392148200-5393-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Add two new flags for open-drain and open-source GPIOs and the
corresponding handling in gpiod_get() to automatically set the
corresponding flags in the GPIO system.

Changes from v1 (suggested by Alexandre Courbot):

  o Add OF_GPIO_OPEN_SOURCE
  o Add automatic propagation of the flags in gpiod_get() et al.

David Daney (2):
  of/gpio: Define OF_GPIO_OPEN_DRAIN and OF_GPIO_OPEN_SOURCE flags.
  of/gpio: Automatically decode OF_GPIO_OPEN_DRAIN and
    OF_GPIO_OPEN_SOURCE flags in gpiolib.

 drivers/gpio/gpiolib.c  | 6 ++++++
 include/linux/of_gpio.h | 2 ++
 2 files changed, 8 insertions(+)

-- 
1.7.11.7

