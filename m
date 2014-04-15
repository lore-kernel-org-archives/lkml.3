Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaDOLHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:07:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39400 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbaDOLHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:07:47 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 0/2] Add more peripherals to the sam9rlek
Date: Tue, 15 Apr 2014 13:07:41 +0200
Message-Id: <1397560063-7439-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this patch set adds support for SPI, LCD, i2c, ADC and touchscreen, USB
gadget and PWM on the at91sam9rlek.

The only missing piece is now audio/ac97 support, then the SoC will be entirely
supported using DT.

Alexandre Belloni (2):
  ARM: at91/dt: sam9rl: add lcd, adc, usb gadget and pwm support
  ARM: at91/dt: add peripherals to the at91sam9rlek board

 arch/arm/boot/dts/at91sam9rl.dtsi  | 265 +++++++++++++++++++++++++++++++++++--
 arch/arm/boot/dts/at91sam9rlek.dts |  90 ++++++++++++-
 2 files changed, 342 insertions(+), 13 deletions(-)

-- 
1.8.3.2

