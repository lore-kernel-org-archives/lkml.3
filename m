Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaBFMWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:22:18 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.113]:51043 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbaBFMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:22:17 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-194.messagelabs.com!1391689333!6745138!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Subject: RE: [PATCH 4/8] regulator: da9055: Add DT support
Thread-Topic: [PATCH 4/8] regulator: da9055: Add DT support
Thread-Index: AQHPIqFBtwUyHGLBMUSnvfWEO0aAwpqoEsvQgAAO4ACAAATiYA==
Date: Thu, 6 Feb 2014 12:22:13 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376B7E36B9@SW-EX-MBX02.diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <6d76ae40cd435eaae0323f3e806515130b06a376.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140205183642.GH32298@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A03376B7E1669@SW-EX-MBX02.diasemi.com>
 <20140206120336.GL32298@sirena.org.uk>
In-Reply-To: <20140206120336.GL32298@sirena.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s16CMOfI004920

On Thu, Feb 06, 2014 at 12:04:52PM +0000, Mark Brown wrote:

> > Used another driver as an example for this, but if there's a better method
> > then I'm happy to use it. Will have a look.
> 
> That's probably an older driver - the code was factored out at some
> point but lots of drivers don't get much love.

Yep, fair enough. Will sort it.

> What's happening here is that the MFD framework has done the lookup for
> you when passing the interrupt resource through - you should just use
> platform_get_irq_byname() and save a little code in the driver.  If it's
> behaving differently on DT and non-DT systems it seems better to figure
> out why and then make it consistent.

Is what I summised but I obviously chose the wrong direction for my fix.
Will use platform_get_irq_byname() solely, and will make sure all works on
both DT and non-DT setups. If not I'll dig further.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
