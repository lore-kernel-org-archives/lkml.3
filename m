Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaIRLxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 07:53:42 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38639 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaIRLxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 07:53:40 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@freescale.com
Cc: stefan@agner.ch, jic23@kernel.org, B38611@freescale.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH v2] Implement temperature sensor for vf610-adc
Date: Thu, 18 Sep 2014 17:23:22 +0530
Message-Id: <cover.1411039381.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vybrid ADC peripheral includes a temperature sensor
which is connected to channel number 26. The patch
adds support for the sensor. The raw value is read
and the temperature calculated in milli degree Celsius,
which is returned using IIO_CHAN_INFO_PROCESSED option.

Sanchayan Maity (1):
  ARM: imx: vf610-adc: Add temperature sensor support

 drivers/iio/adc/vf610_adc.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

-- 
1.7.9.5

