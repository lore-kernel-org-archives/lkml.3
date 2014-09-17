Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaIQIYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:24:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58600 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaIQIYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:24:12 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, B38611@freescale.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@kernel.org, linux-iio@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 0/2] Add ADC support for Colibri VF61 and implement temperature sensor for vf610-adc
Date: Wed, 17 Sep 2014 13:53:15 +0530
Message-Id: <cover.1410873422.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ADC nodes for Colibri VF61 modules.

Vybrid ADC module includes a temperature sensor which
is connected to channel number 26. This patch adds
support for the sensor. The raw value is read and the
temperature calculated in degree Celsius which is
returned using the IIO_CHAN_INFO_PROCESSED option.

Sanchayan Maity (2):
  ARM: dts: vf610-colibri: Add ADC support
  ARM: imx: vf610-adc: Add temperature sensor support

 arch/arm/boot/dts/vf610-colibri.dtsi |   10 ++++++++++
 drivers/iio/adc/vf610_adc.c          |   34 +++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

-- 
1.7.9.5

