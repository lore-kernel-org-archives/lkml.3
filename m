Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaH1M2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:28:20 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9006 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaH1M2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:28:18 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-8b-53ff205f67b1
Message-id: <1409228894.25322.15.camel@AMDC1943>
Subject: Re: [PATCH v4 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 28 Aug 2014 14:28:14 +0200
In-reply-to: <20140828115219.GQ24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-7-git-send-email-k.kozlowski@samsung.com>
 <20140828115219.GQ24579@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e/4Nd14hf/BBksPWFlsnLGe1WLqwyds
	FpOevGe2mLhyMrNF/5uFrBbnXq1ktDjb9Ibd4v7Xo4wW3650MFls/t7BZnF51xw2i8+9Rxgt
	1h65y26x9PpFJosJ09eyWLTuPcJucbqb1eL07hIHIY8189Ywelzu62Xy2DnrLrvHyuVf2Dw2
	r9Dy2LSqk83jzrU9bB7zTgZ69G1ZxejxeZNcAFcUl01Kak5mWWqRvl0CV8aJqfcZCz5yVvzd
	doGpgfEDexcjJ4eEgInE7ZPPWCBsMYkL99azdTFycQgJLGWUmPrxBSuE85lRYu+lVrAOXgED
	iVvNa8FsYYFgiUNvVjCB2GwCxhKbly8B6ubgEBFQkTj3xhykl1lgOqvEqm1fGEFqWARUJdpu
	HGYGsTkFdCWuNUwFs4UEVjBKbP2dA2IzC6hLTJq3iBlkjoSAskRjvxvEWkGJH5PvsUCUyEts
	XvOWeQKjwCwkHbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkj0fdnBuPiY
	1SFGAQ5GJR7eDaX/goVYE8uKK3MPMUpwMCuJ8G6S/B8sxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gTF2l4K6nceJd8sU812m79PMnZ14dGkhe8eOzrBFV7LeZFj88n53NHNeXCCTxdTKN0VCO26X
	HjxSlJA37cGkb2YK/RcsP7xOnh0QqHaUWWGS5K8Vf5cLMnsaSV/V3RInyuR6fjPjtKePD3ZM
	4pFY/PfMi1fTPsVkzHvx7ejTHxsnuD57dn96HnuyEktxRqKhFnNRcSIA5f586ZwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-08-28 at 12:52 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> 
> > MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
> > can be safely re-used. The patch adds MAX77836 ID to array of
> > i2c_device_id.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/power/max17040_battery.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
> > index 0fbac861080d..165ffe381803 100644
> > --- a/drivers/power/max17040_battery.c
> > +++ b/drivers/power/max17040_battery.c
> > @@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
> >  
> >  static const struct i2c_device_id max17040_id[] = {
> >  	{ "max17040", 0 },
> > +	{ "max77836-battery", 0 },
> 
> Are you sure you want the IDs to be the same?
> 
> If they are not used, just drop them entirely.

They are not used but you're right that the ID should be different. I'll
add an local enum for the ID.

Thanks for feedback!
Krzysztof

> 
> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(i2c, max17040_id);
> 

