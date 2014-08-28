Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbaH1Niw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:38:52 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.120]:23665 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731AbaH1Niv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:38:51 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-6.tower-194.messagelabs.com!1409233105!19463174!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>, Axel Lin <axel.lin@ingics.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Support Opensource <Support.Opensource@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: da9052: Avoid setting read_flag_mask for
 da9052-i2c driver
Thread-Topic: [PATCH] mfd: da9052: Avoid setting read_flag_mask for
 da9052-i2c driver
Thread-Index: AQHPuVVRn2UBiyep9UC8mpS+x6e+UZvl4NIAgAAjh/A=
Date: Thu, 28 Aug 2014 13:38:23 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB51182B@SW-EX-MBX01.diasemi.com>
References: <1408195420.21225.2.camel@phoenix>
 <20140828112052.GL24579@lee--X1>
In-Reply-To: <20140828112052.GL24579@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7SDcwfS018472

On August 28, 2014 12:21, Lee Jones wrote:

> Steve, Adam,
> 
> > Current code init regmap with &da9052_regmap_config for both da9052-spi and
> > da9052-i2c drivers. da9052-spi sets the read_flag_mask.
> > The same setting may be applied for da9052-i2c if da9052-spi driver is loaded
> > first because they actually use the same regmap_config setting.
> > Fix this issue by using a local variable for regmap_config in da9052-spi driver,
> > so the settings in spi driver won't impact the settings in i2c driver.
> > Also makes da9052_regmap_config const to avoid similar issue.
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> > ---
> > Hi Adam and Steve,
> > Any chance to test this patch?
> 
> ** Look here **

Lee, Axel,

This was on my to-do list but hadn't yet responded. Will try and find some time
in the next week to see if we can verify this.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
