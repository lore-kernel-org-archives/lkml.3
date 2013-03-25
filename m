Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3CYIcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:32:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37292 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3CYIcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:32:10 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        "jacmet@sunsite.dk" <jacmet@sunsite.dk>
Subject: RE: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in
 DAVINCI.
Thread-Topic: [PATCH v3 0/3] Platform support for EHRPWM & ECAP devices in
 DAVINCI.
Thread-Index: AQHOKS025VCF1N5DVkK+rONLQqIK75i1swaAgABgHZA=
Date: Mon, 25 Mar 2013 08:30:45 +0000
Deferred-Delivery: Mon, 25 Mar 2013 08:30:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EAA19F4@DBDE01.ent.ti.com>
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com>
 <5150076D.3080904@ti.com>
In-Reply-To: <5150076D.3080904@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2P8WHPW026421

On Mon, Mar 25, 2013 at 13:44:37, Nori, Sekhar wrote:
> On 3/25/2013 1:19 PM, Philip Avinash wrote:
> > Add platform support for EHRPWM and ECAP by providing clock nodes and
> > device tree nodes.
> > This series depends on [1] and [2] and is available for testing at [3].
> > Tested for back light support in da850 EVM with EHRPWM PWM device.
> > 
> > [1] http://gitorious.org/linux-davinci/linux-davinci/trees/davinci-for-v3.9/dt-2
> > [2] https://gitorious.org/linux-pwm/linux-pwm/trees/for-next
> > [3] https://github.com/avinashphilip/am335x_linux/tree/davinci-for-v3.9_soc_pwm
> > 
> > Note:
> > DT support for EHRPWM backlight has not been added in da850-evm.dts as there is
> > conflicting pin-mux requirement with SPI flash.
> > 
> > Philip Avinash (3):
> >   ARM: davinci: clk framework support for enable/disable functionality
> 
> Patch 1/3 did not reach me. I cant find it in archives either so most
> likely no one received it. Can you please send that one patch again?

Done.

> 
> >   arm: davinci: clock node support for ECAP & EHRPWM
> 
> For future, please be consistent and capitalize 'ARM' in subject line.

Ok I will take care.

Thanks
Avinash
> 
> >   ARM: davinci: da850: add EHRPWM & ECAP DT node
> > 
> >  arch/arm/boot/dts/da850.dtsi               |   30 ++++++++++++++++++
> >  arch/arm/mach-davinci/clock.c              |   21 ++++++++-----
> >  arch/arm/mach-davinci/clock.h              |    2 ++
> >  arch/arm/mach-davinci/da850.c              |   46 ++++++++++++++++++++++++++++
> >  arch/arm/mach-davinci/da8xx-dt.c           |    5 +++
> >  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
> >  6 files changed, 98 insertions(+), 7 deletions(-)
> > 
> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
