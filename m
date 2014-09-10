Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaIJJva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 05:51:30 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33210 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaIJJv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 05:51:26 -0400
Date: Wed, 10 Sep 2014 10:51:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Varka Bhadram <varkabhadram@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: Re: [PATCH v2 1/7] mfd: Add support for DA9150 combined charger &
 fuel-gauge device
Message-ID: <20140910095119.GO30307@lee--X1>
References: <cover.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <d6c7de200c9447dbafa74ee76739da943a0b73b2.1409145187.git.Adam.Thomson.Opensource@diasemi.com>
 <53FF16BC.9050701@gmail.com>
 <2E89032DDAA8B9408CB92943514A0337AB5144B5@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB5144B5@SW-EX-MBX01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Opensource [Adam Thomson] wrote:
> On August 28, 2014 12:47, Varka Bhadram wrote:
> 
> > On 08/28/2014 04:18 PM, Adam Thomson wrote:
> > 
> > (...)
> > 
> > > +static int da9150_probe(struct i2c_client *client,
> > > +			const struct i2c_device_id *id)
> > > +{
> > > +	struct da9150 *da9150;
> > > +	int ret;
> > > +
> > > +	da9150 = devm_kzalloc(&client->dev, sizeof(struct da9150), GFP_KERNEL);
> > > +	if (da9150 == NULL)
> > > +		return -ENOMEM;
> > 
> > da9150 = devm_kzalloc(&client->dev, sizeof(*da9150), GFP_KERNEL);
> > if (!da9150)
> > 	return -ENOMEM;
> 
> Ok, no real difference, but can change it.

Not functionally, but we like to do things as succinctly as possible.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
