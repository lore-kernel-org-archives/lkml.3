Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaCMMQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 08:16:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44839 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaCMMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 08:16:40 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-a4-5321a1a5205f
Message-id: <1394712996.20773.1.camel@AMDC1943>
Subject: Re: [PATCH v2 2/3] mfd: sec-core: Add of_compatible strings for MFD
 cells
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Thu, 13 Mar 2014 13:16:36 +0100
In-reply-to: <53219F80.9000300@samsung.com>
References: <1394703425-6462-1-git-send-email-k.kozlowski@samsung.com>
 <1394703425-6462-3-git-send-email-k.kozlowski@samsung.com>
 <53219F80.9000300@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xq7pLFyoGG5zcZmGxccZ6VouzTW/Y
	Le5/PcposenxNVaLy7vmsFnMOL+PyWLtkbvsFk8nXGSzOPmnl9HidDerxcUVX5gs1s94zWLR
	/ncvm8Wc6e+YHPg87lzbw+Yx72Sgx+Yl9R59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV0fp2
	OVPBbP6KB7t3MzUwHuXuYuTkkBAwkbi+8Sk7hC0mceHeejYQW0hgKaPEhFOcXYxcQPZnRomL
	MzYwdTFycPAK6Ev83BQCUiMsECLRtuc8WD2bgLHE5uVLwGwRARWJy6emM4L0MgvMZZGY/fos
	M0iCRUBV4uP5H2DLOAW0JU62/mCBWLCEUaJ5/hNGkASzgLrEpHmLmCEuUpLY3d7JDhGXl9i8
	5i1YnFdAUOLH5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcx
	QuLkyw7GxcesDjEKcDAq8fCuWK4QLMSaWFZcmXuIUYKDWUmEV22OYrAQb0piZVVqUX58UWlO
	avEhRiYOTqkGxkn3efzYz+60C5jdK+astP9ouW9E9O8IO98WzehHz+TfveDZc67tbfO6908v
	Lt9f/vtA/L0lGuct7tatjW6qe8CjdLPtRvOLM5Pycp9qzgx/XDc14sCjU1xXue3PnHbdrsu0
	lXvGF/eb/kKeR/7c3vE+RnPi7o9nGrR/bGFY+U8zeu3hpwdllncosRRnJBpqMRcVJwIAV4UK
	6nECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 13:07 +0100, Tomasz Figa wrote:
> Hi Krzysztof,
> 
> On 13.03.2014 10:37, Krzysztof Kozlowski wrote:
> > Add of_compatible strings for MFD cells for regulator, clock and RTC
> > drivers in S5M8767, S2MPS11 and S2MPS14 PMIC-s.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >   drivers/mfd/sec-core.c |    8 ++++++++
> >   1 file changed, 8 insertions(+)
> >
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > index d163c66edebb..c5b9b95b2099 100644
> > --- a/drivers/mfd/sec-core.c
> > +++ b/drivers/mfd/sec-core.c
> > @@ -55,28 +55,36 @@ static const struct mfd_cell s5m8763_devs[] = {
> >   static const struct mfd_cell s5m8767_devs[] = {
> >   	{
> >   		.name = "s5m8767-pmic",
> > +		.of_compatible = "samsung,s5m8767-regulators",
> >   	}, {
> >   		.name = "s5m-rtc",
> > +		.of_compatible = "samsung,s5m8767-rtc",
> >   	}, {
> >   		.name = "s5m8767-clk",
> > +		.of_compatible = "samsung,s5m8767-clk",
> >   	}
> >   };
> >
> >   static const struct mfd_cell s2mps11_devs[] = {
> >   	{
> >   		.name = "s2mps11-pmic",
> > +		.of_compatible = "samsung,s2mps11-regulators",
> >   	}, {
> >   		.name = "s2mps11-clk",
> > +		.of_compatible = "samsung,s2mps11-clk",
> >   	}
> >   };
> >
> >   static const struct mfd_cell s2mps14_devs[] = {
> >   	{
> >   		.name = "s2mps14-pmic",
> > +		.of_compatible = "samsung,s2mps14-regulators",
> >   	}, {
> >   		.name = "s2mps14-rtc",
> > +		.of_compatible = "samsung,s2mps14-rtc",
> >   	}, {
> >   		.name = "s2mps14-clk",
> > +		.of_compatible = "samsung,s2mps14-clk",
> >   	}
> >   };
> 
> Are these compatible strings documented anywhere?

The "-clk" compatible strings are (in next patch). The "-rtc" and
"-regulators" are not.

Actually they aren't also used by child driver (each child driver parses
from parent of_node).

Best regards,
Krzysztof


