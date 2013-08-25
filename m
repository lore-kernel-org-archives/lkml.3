Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3HYWpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 18:45:30 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:61508 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3HYWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 18:45:28 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk, lee.jones@linaro.org
Cc: bigeasy@linutronix.de, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH V6 0/2] iio: input: ti_am335x_adc: Add continuous sampling support 
Date: Sun, 25 Aug 2013 23:45:22 +0100
Message-Id: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies to togreg branch in iio.

Round 6 updates
Fixed trigger the way iio list wanted. Driver has its own trigger.
Triggers at every FIFO Threshold IRQ and pushes samples to iio buffer.

Went through the driver and cleaned it up quite a bit.

Squashed patches together instead of having multiple tiny patches.

Zubair Lutfullah (2):
  input: ti_am335x_tsc: Enable shared IRQ for TSC
  iio: ti_am335x_adc: Add continuous sampling support

 drivers/iio/adc/ti_am335x_adc.c           |  254 ++++++++++++++++++++++++++---
 drivers/input/touchscreen/ti_am335x_tsc.c |   24 ++-
 include/linux/mfd/ti_am335x_tscadc.h      |   13 ++
 3 files changed, 264 insertions(+), 27 deletions(-)

-- 
1.7.9.5

