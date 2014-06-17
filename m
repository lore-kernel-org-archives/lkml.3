Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaFQIVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:21:46 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.138]:32504 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870AbaFQIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:21:44 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-13.tower-178.messagelabs.com!1402993300!35473235!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 6/8] power: Add support for DA9150 Charger
Thread-Topic: [PATCH 6/8] power: Add support for DA9150 Charger
Thread-Index: AQHPhWXpFIM+NG1A5k+ZaFzMMiYmiptzsfmAgAFM0lA=
Date: Tue, 17 Jun 2014 08:21:39 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB4FDA47@SW-EX-MBX01.diasemi.com>
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <d4ef0d7ce2d6a2919d528ed75e82d2b99ec8d962.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
 <20140616132749.GW14323@lee--X1>
In-Reply-To: <20140616132749.GW14323@lee--X1>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5H8Lq1Z005439

On June 16, 2014 14:28, Lee Jones wrote:

> > +#ifndef _DA9150_CHARGER_H
> > +#define _DA9150_CHARGER_H
> 
> Two '_'s are normally preferred.

Ok, can change it accordingly.

> 
> > +#include <linux/device.h>
> > +#include <linux/i2c.h>
> 
> What are you using this for?

Nothing. Will remove them. Thanks.

> > +#include <linux/mfd/da9150/core.h>
> > +
> > +
> 
> Extra '\n' here.

Yes, just separate includes from the rest of the file. Find it more readable.
If it's an issue though I can remove it.

> > +	struct power_supply ac;
> > +	struct power_supply usb;
> > +	struct power_supply battery;
> 
> Do you want these (or pointers to these) here?
> 
> How much space do they take up?

Yes these are required in that structure. This is the common approach for
power_supply drivers. The structures, having had a very quick look, are around
maybe 70 bytes each.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
