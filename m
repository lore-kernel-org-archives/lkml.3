Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaB0V36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:29:58 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:49202 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaB0V34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:29:56 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, hns@goldelico.com, sre@ring0.de,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH 0/3] Convert twl4030_madc_battery to IIO and add DT aupport
Date: Thu, 27 Feb 2014 22:29:27 +0100
Message-Id: <1393536570-29969-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches are based on Sebastian Reichel work [1] which convert twl4030_madc mfd to iio
framework. Patches was tested on gta04 board. twl4030_madc_battery driver is converted in
first patch to iio consumer and in next patches is added support for devicetree.

[1] - https://lkml.org/lkml/2014/2/26/482

Marek Belisko (3):
  power: twl4030-madc-battery: Convert to iio consumer.
  power: twl4030_madc_battery: Add device tree support.
  Documentation: DT: Document twl4030-madc-battery bindings.

 .../bindings/power_supply/twl4030_madc_battery.txt |  43 ++++++
 drivers/power/twl4030_madc_battery.c               | 155 ++++++++++++++++-----
 2 files changed, 165 insertions(+), 33 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt

-- 
1.8.3.2

