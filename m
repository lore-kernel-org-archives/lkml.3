Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBGPpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:45:19 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.141]:15167 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbaBGPpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:45:16 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-4.tower-180.messagelabs.com!1391787912!25543238!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Subject: RE: [PATCH v2 3/8] mfd: da9055: Add DT support for PMIC
Thread-Topic: [PATCH v2 3/8] mfd: da9055: Add DT support for PMIC
Thread-Index: AQHPI/Q6dJ84YLPe60WF/sjOMpRzV5qp7tlQ
Date: Fri, 7 Feb 2014 15:45:11 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376BACFBC6@SW-EX-MBX01.diasemi.com>
References: <cover.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <46f41a14205ac39de3adb8c87d2a6dba557ad8d1.1391705989.git.Adam.Thomson.Opensource@diasemi.com>
 <20140207110320.GM14727@lee--X1>
In-Reply-To: <20140207110320.GM14727@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s17FjQ8u016212

On Fri, Feb 07, 2014 at 11:03:18AM +0000, Lee Jones wrote:

> 
> Can you break this up please.
> 
> Bindings should be separate to the binding document.

Right, fine. Figured as they were directly related they should be in one patch
but will separate them.

> Entangling the i2c_device_id table with the of_device_id table sounds
> a bit too wacky for my liking. Where do you even use it?
> 

You're right. Is not used so can remove it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
