Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbaHZOmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:42:49 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.151]:34995 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaHZOmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:42:47 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2014 10:42:46 EDT
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-9.tower-180.messagelabs.com!1409063746!40112456!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Guenter Roeck <linux@roeck-us.net>
CC: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        "knaack.h@gmx.de" <knaack.h@gmx.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iio: core: Propagate error codes from OF layer to
 client drivers
Thread-Topic: [PATCH] iio: core: Propagate error codes from OF layer to
 client drivers
Thread-Index: AQHPwGQgHemXEHhucEq2pC0/gK7aa5vhbKOAgAAMSgCAAPqfAIAAXTaAgAAGhgCAABv1cA==
Date: Tue, 26 Aug 2014 14:35:45 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB510FA9@SW-EX-MBX01.diasemi.com>
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
		 <53FB5FF7.8020504@kernel.org> <20140825165430.GB14614@roeck-us.net>
	 <1409039490.5256.75.camel@iivanov-dev> <53FC8AB3.2080603@roeck-us.net>
 <1409060908.5256.83.camel@iivanov-dev>
In-Reply-To: <1409060908.5256.83.camel@iivanov-dev>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7QEgrb0003222

On August 26, 2014 14:48, Ivan T. Ivanov wrote:

> On Tue, 2014-08-26 at 06:25 -0700, Guenter Roeck wrote:
> > On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
> > > Hi,
> > >
> > [ ... ]
> > >
> > > Another, less intrusive, solution will be if we revert last patch and explicitly
> > > check for EPROBE_DEFER on of_ by_name() return. How this sounds?
> > >
> > How is that different to the just accepted patch ?
> 
> You mean this one[1]. I have prepared fix last Friday and forget to
> check again before posting it, sorry. Please ignore my patch.
> 
> Thanks,
> Ivan
> 
> [1] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
> 

Apologies on my part for fixing one problem and introducing another. Didn't see
that in my testing, and missed that potential return value when examining the
code. At the time It looked like the parent function would only expect NULL
pointers for failure, especially given the non CONFIG_OF definitions of the
functions. Should've delved further. :(
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
