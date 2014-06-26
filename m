Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaFZHkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:40:33 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:45129 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbaFZHkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:40:31 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 03:40:30 EDT
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-11.tower-194.messagelabs.com!1403768053!20577815!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 26 Jun 2014 09:34:13 +0200
From: "Thumshirn, Johannes Tobias" <Johannes.Thumshirn@men.de>
To: Bryan Wu <cooloney@gmail.com>, "Werner, Andreas" <Andreas.Werner@men.de>
CC: lkml <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: AW: [PATCH v2 3/3] drivers/leds/leds-menf21bmc: introduce MEN
 14F021P00 BMC LED driver
Thread-Topic: [PATCH v2 3/3] drivers/leds/leds-menf21bmc: introduce MEN
 14F021P00 BMC LED driver
Thread-Index: AQHPeYPXiaocpyWn/0Gm+eaZqg2PAZuCgN+AgACtxWA=
Date: Thu, 26 Jun 2014 07:34:12 +0000
Message-ID: <c122906fd903476dac6c64041ca512c4@MEN-EX01.intra.men.de>
References: <cover.1401181010.git.andreas.werner@men.de>
 <d06aca002784396a95beac921f296d812e1eeb4b.1401181010.git.andreas.werner@men.de>
 <CAK5ve-LaiqT8xy_LN7O6FeUSvCcJj3kGu1u5AQz2OH2Q4gGMyQ@mail.gmail.com>
In-Reply-To: <CAK5ve-LaiqT8xy_LN7O6FeUSvCcJj3kGu1u5AQz2OH2Q4gGMyQ@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.3.39]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5Q7eg74015661

> Von: Bryan Wu [mailto:cooloney@gmail.com]
> Gesendet: Donnerstag, 26. Juni 2014 01:11
> An: Werner, Andreas
> Cc: lkml; Samuel Ortiz; Lee Jones; wim@iguana.be; linux-
> watchdog@vger.kernel.org; rpurdie@rpsys.net; Linux LED Subsystem;
> Thumshirn, Johannes Tobias
> Betreff: Re: [PATCH v2 3/3] drivers/leds/leds-menf21bmc: introduce MEN
> 14F021P00 BMC LED driver
> 
> On Tue, May 27, 2014 at 2:08 AM, Andreas Werner
> <andreas.werner@men.de> wrote:
> > Added driver to support the 14F021P00 BMC LEDs.
> > The BMC is a Board Management Controll include four LEDs which
> > can be switched on and off.
> >
> > This driver use the I2C interface to the BMC using the menf21bmc MFD Core
> driver.
> >
> 
> Will you submit v2 patch based on Lee and others' review? I prefer to
> review the new one.
> 
> Thanks,
> -Bryan

Hi,
Andreas is currently on vacation, but he'll send a v3 as soon as he's back.

Johannes
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
