Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbbA0QPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:15:51 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.142]:61138 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbbA0QPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:15:49 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-9.tower-179.messagelabs.com!1422375339!42678930!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v6 3/7] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH v6 3/7] iio: Add support for DA9150 GPADC
Thread-Index: AQHQNZF8ORkXLSaNsUepskb8DDsVZZzKvWCAgAlrjKA=
Date: Tue, 27 Jan 2015 16:15:37 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB529E60@SW-EX-MBX01.diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
 <ae9b56cc8cd15bd72ea1b721ae02b1dde8632dbf.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
 <54BFCE97.4050007@gmail.com>
In-Reply-To: <54BFCE97.4050007@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0RGFtGU027035

On January 21, 2015 16:07, Varka Bhadram wrote:

> On Wednesday 21 January 2015 09:16 PM, Adam Thomson wrote:
> > This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.
> >
> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> > Acked-by: Jonathan Cameron <jic23@kernel.org>
> 
> (...)
> 
> > +
> > +static int da9150_gpadc_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
> > +	struct da9150_gpadc *gpadc;
> > +	struct iio_dev *indio_dev;
> > +	int irq, ret;
> > +
> > +	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*gpadc));
> 
>   You can directly use *dev* instead of *&pdev->dev*

Yes agreed. Can follow up with change for this as it's not urgent and would
rather leave current patch set as is.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
