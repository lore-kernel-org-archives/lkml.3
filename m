Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaISM66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:58:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43994 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbaISM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:58:57 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: jic23@kernel.org
Cc: stefan@agner.ch, shawn.guo@freescale.com, B38611@freescale.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH v3] drivers/iio/adc/vf610-adc: Add temperature sensor support
Date: Fri, 19 Sep 2014 18:28:41 +0530
Message-Id: <cover.1411128738.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vybrid ADC peripheral includes a temperature sensor
which is connected to channel number 26. This patch
adds support for the sensor. The raw value is read
and the temperature calculated in milli degree Celsius,
which is returned using IIO_CHAN_INFO_PROCESSED option.

Changes since v2:
v2 and v1 patch were with "ARM: imx:" Cleaned this.

Changes since v1:
[1] Removed info scale, index and sampling frequency 
specification for temperature channel.
[2] Instead of having info->value as int for temperature
calculation, kept it at u32 and only read value during 
temperature calculation

[v1] http://thread.gmane.org/gmane.linux.kernel.iio/13960/focus=13963
[v2] https://lkml.org/lkml/2014/9/18/161

Sanchayan Maity (1):
  drivers/iio/adc/vf610-adc: Add temperature sensor support

 drivers/iio/adc/vf610_adc.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

-- 
1.7.9.5

