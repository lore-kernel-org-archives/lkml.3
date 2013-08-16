Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3HPKR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:17:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:38617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HPKRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:17:22 -0400
Date: Fri, 16 Aug 2013 12:17:14 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Russ.Dill@ti.com
Subject: Re: [PATCH 4/4] iio: ti_am335x_adc: Add continuous sampling and
 trigger support
Message-ID: <20130816101714.GE26895@linutronix.de>
References: <1376424303-22740-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376424303-22740-5-git-send-email-zubair.lutfullah@gmail.com>
 <520CBEC6.8010400@kernel.org>
 <20130816100702.GD26895@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130816100702.GD26895@linutronix.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2013-08-16 12:07:02 [+0200]:

>* Jonathan Cameron | 2013-08-15 12:43:02 [+0100]:
>
>It did apply with no trouble here.

and with

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 93129ec..fdd9810 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -156,6 +156,7 @@ config TI_ADC081C
 config TI_AM335X_ADC
 	tristate "TI's ADC driver"
 	depends on MFD_TI_AM335X_TSCADC
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say yes here to build support for Texas Instruments ADC
 	  driver which is also a MFD client.


it links :)

Sebastian
