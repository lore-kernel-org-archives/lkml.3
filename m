Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3GBGPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:15:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53940 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3GBGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:15:03 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        =?utf-8?B?QmVub8OudCBDb3Vzc29u?= <benoit.cousson@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Subject: RE: [PATCH 4/4] ARM: dts: AM33XX: update rtc node compatibility
Thread-Topic: [PATCH 4/4] ARM: dts: AM33XX: update rtc node compatibility
Thread-Index: AQHOc+J1f8AO46OdWkqH7B3vNxGLJplQaHmAgACGcPA=
Date: Tue, 2 Jul 2013 06:14:30 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC4E7E6@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
 <1372412109-986-5-git-send-email-gururaja.hebbar@ti.com>
 <51D26F61.7080308@ti.com>
In-Reply-To: <51D26F61.7080308@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r626FF6g005887

On Tue, Jul 02, 2013 at 11:42:49, Nori, Sekhar wrote:
> Changing to Benoit's gmail id since he apparently wont access TI mail
> anymore.
> 
> On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> > Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
> > 
> > Update the rtc compatible property to "ti,am3352-rtc" to enable handling
> > of this feature inside rtc-omap driver.
> > 
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: b-cousson@ti.com
> > ---
> > :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
> >  arch/arm/boot/dts/am33xx.dtsi |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index 77aa1b0..dde180a 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -297,7 +297,7 @@
> >  		};
> >  
> >  		rtc@44e3e000 {
> > -			compatible = "ti,da830-rtc";
> > +			compatible = "ti,am3352-rtc";
> 
> compatible is a list so you can instead do:
> 	
> 	compatible = "ti,am3352-rtc", "ti,da830-rtc";
> 
> That way the dts works irrespective of driver updates. When driver
> supports enhanced features of hardware, they are available to the user
> else the basic functionality still works.

Ok. I will update the same now in v2.

> 
> Thanks,
> Sekhar
> 


Regards, 
Gururaja
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
