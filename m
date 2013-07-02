Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3GBFmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:42:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45001 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3GBFmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:42:18 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: RE: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device wakeup
Thread-Topic: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device wakeup
Thread-Index: AQHOc+J0RsbXSUDawkGOsr/q2+BaoplQX14AgACGVwA=
Date: Tue, 2 Jul 2013 05:41:37 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC4E74E@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
 <1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
 <51D267BE.8090605@ti.com>
In-Reply-To: <51D267BE.8090605@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r625gODx005620

On Tue, Jul 02, 2013 at 11:10:14, Nori, Sekhar wrote:
> 
> On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> > Since now rtc-omap driver itself calls deice_init_wakeup(dev, true),
> > duplicate call from the rtc device registration can be removed.
> > 
> > This is basically a partial revert of the prev commit
> > 
> > commit 75c99bb0006ee065b4e2995078d779418b0fab54
> > Author: Sekhar Nori <nsekhar@ti.com>
> > 
> >     davinci: da8xx/omap-l1: mark RTC as a wakeup source
> > 
> > Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> > Cc: Sekhar Nori <nsekhar@ti.com>
> > Cc: Kevin Hilman <khilman@linaro.org>
> > Cc: Russell King <linux@arm.linux.org.uk>
> 
> Subject line should be prefixed with ARM: keeping with arch/arm
> convention. Otherwise looks good.

Will fix it in v2.

> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks for the review.

> 
> Thanks,
> Sekhar
> 


Regards, 
Gururaja
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
