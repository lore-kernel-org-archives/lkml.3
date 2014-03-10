Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaCJMxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:53:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32013 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaCJMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:53:23 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-39-531db5c10efa
Message-id: <1394455999.16208.3.camel@AMDC1943>
Subject: Re: [PATCH 2/3] mfd: sec-core: Add of_compatible strings for MFD cells
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Date: Mon, 10 Mar 2014 13:53:19 +0100
In-reply-to: <20140310124623.GA18561@lee--X1>
References: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
 <1394454858-3139-3-git-send-email-k.kozlowski@samsung.com>
 <20140310124623.GA18561@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xa7oHt8oGG/Q9FLfYOGM9q8XZpjfs
	Fve/HmW02PT4GqvF5V1z2CxmnN/HZLH2yF12i6cTLrJZnPzTy2hxupvV4uKKL0wW62e8ZrFo
	/7uXzWLO9HdMDnwed67tYfOYdzLQY/OSeo++LasYPT5vkgtgjeKySUnNySxLLdK3S+DK6Gw5
	wFQwm6tizonFjA2MH9i7GDk5JARMJL6c2s4GYYtJXLi3Hsjm4hASWMoosWv9OmYI5zOjxNx5
	Kxi7GDk4eAX0JebeUwNpEBbwlzj45SILiM0mYCyxefkSNpASEQEViXNvzEFamQXmskhs6H/K
	DFLDIqAqceb3RbBlnAK6EhfnvmGBmL+MUWLdx0Vgg5gF1CUmzVvEDHGRksTu9k52iLi8xOY1
	b8HivAKCEj8m32OZwCgwC0nLLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kR
	EidfdzAuPWZ1iFGAg1GJh/fAW5lgIdbEsuLK3EOMEhzMSiK8mYtlg4V4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwHllv9/PtS2XzxQFax+rbgwolrQsYHB7f5pWXumJim+F69M88u88v1O3nGAWL
	zbV5/+WA+Qyv4Hvll+q88+90BM77sSlnc8WSu73901j7I/ZOZeZ/FhPAcDr18noXj/mMvR3+
	u3h+ub9IqePZZMKRYMq757dV1FGm6ZIif/dEWa/+Pt/jRa2rEktxRqKhFnNRcSIATm3crXEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 12:46 +0000, Lee Jones wrote:
> > Add of_compatible strings for S5M8767 RTC, S5M8767 clock and S2MPS14
> > clock MFD cells.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > index d163c66edebb..e8ac2e3c1f58 100644
> > --- a/drivers/mfd/sec-core.c
> > +++ b/drivers/mfd/sec-core.c
> > @@ -57,8 +57,10 @@ static const struct mfd_cell s5m8767_devs[] = {
> >  		.name = "s5m8767-pmic",
> >  	}, {
> >  		.name = "s5m-rtc",
> > +		.of_compatible = "samsung,s5m8767-rtc",
> >  	}, {
> >  		.name = "s5m8767-clk",
> > +		.of_compatible = "samsung,s5m8767-clk",
> >  	}
> >  };
> >  
> > @@ -77,6 +79,7 @@ static const struct mfd_cell s2mps14_devs[] = {
> >  		.name = "s2mps14-rtc",
> >  	}, {
> >  		.name = "s2mps14-clk",
> > +		.of_compatible = "samsung,s2mps14-clk",
> >  	}
> >  };
> 
> Any reason for not applying compatible strings for the other devices?

Partially yes because I do not want to add them for devices which I
cannot test (s5m8761, s5m8763) but you're right that there are no
obstacles for s2mps11, s5m8767 and s2mps14.

I'll fix this in next version.

