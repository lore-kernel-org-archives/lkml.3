Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3LQOGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:06:40 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27990 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3LQOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:06:37 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-5c-52b05a6bc91d
Message-id: <1387289193.13191.9.camel@AMDC1943>
Subject: Re: [PATCH 1/5] regulator: s5m8767: Add symbols for hard-coded
 DVS_RAMP register
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Date: Tue, 17 Dec 2013 15:06:33 +0100
In-reply-to: <20131217135153.GI19810@lee--X1>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-2-git-send-email-k.kozlowski@samsung.com>
 <20131217135153.GI19810@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xK7rZURuCDP7MlLRouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJanG16w25x/+tRRotvVzqYLBa2LWGxuLxrDpvF2iN32S2W
	Xr/IZDFh+loWi8MrDjBZrHs5ncXi5J9eRovT3awWF1d8YbI4NmMJo4OIx5p5axg9Fny+wu5x
	ua+XyWPnrLvsHiuXf2Hz2LSqk83j1eqZrB53ru1h85h3MtCjb8sqRo/Pm+QCuKO4bFJSczLL
	Uov07RK4MnY9fcdc0Mdb8fj6VsYGxlNcXYycHBICJhK/e5ezQthiEhfurWfrYuTiEBJYyigx
	8QhIAsT5zCjxaOV0NpAqXgF9id+HVrOA2MIC0RLLfy9mArHZBIwlNi9fAlTDwSEioCJx7o05
	SJhZ4D6rxJJ+ThCbRUBVomfBM7BWTgFdiY97X0EtW8EosX7WWkaIBnWJSfMWMUNcpCSxu72T
	HSIuL7F5zVtmiBsEJX5MvscygVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJD6/7GBcfMzqEKMAB6MSD++O+euDhFgTy4orcw8xSnAwK4nwPgjcECTEm5JYWZVa
	lB9fVJqTWnyIkYmDU6qBMfJmrMXc+68UAxRvMt9r5eB967t7WXRfWZ3+jdgFuoveSubKGOoc
	dNd/mT/FL0YjYtqm+an1h5N2M1w1KTj7V/fMsjget4hvSQLxP/fKdq86zf/ePlLzl9LvtPCo
	ldx3N8cuXD1pcvbBfRrr2ifcZ3gcl5LWUvEmX+y3XFqpaXAtm+dc9ub1SizFGYmGWsxFxYkA
	y3iui60CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 13:51 +0000, Lee Jones wrote:
> > Add symbols for hard-coded values of BUCK_RAMP field in DVS_RAMP
> > register. This simplifies a little the code as register update is called
> > only once.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/regulator/s5m8767.c         |   22 ++++++++++------------
> >  include/linux/mfd/samsung/s5m8767.h |   15 +++++++++++++++
> >  2 files changed, 25 insertions(+), 12 deletions(-)
> 
> <snip>
> 
> > diff --git a/include/linux/mfd/samsung/s5m8767.h b/include/linux/mfd/samsung/s5m8767.h
> > index 9198377ee859..2ab0b0f03641 100644
> > --- a/include/linux/mfd/samsung/s5m8767.h
> > +++ b/include/linux/mfd/samsung/s5m8767.h
> > @@ -186,4 +186,19 @@ enum s5m8767_regulators {
> >  #define S5M8767_ENCTRL_SHIFT		6
> >  #define S5M8767_ENCTRL_MASK		(0x3 << S5M8767_ENCTRL_SHIFT)
> >  
> > +/*
> > + * Values for BUCK_RAMP field in DVS_RAMP register, matching raw values
> > + * in mV/us.
> > + */
> > +enum s5m8767_dvs_buck_ramp_values {
> > +	S5M8767_DVS_BUCK_RAMP_5		= 0x4,
> > +	S5M8767_DVS_BUCK_RAMP_10	= 0x9,
> > +	S5M8767_DVS_BUCK_RAMP_12_5	= 0xb,
> > +	S5M8767_DVS_BUCK_RAMP_25	= 0xd,
> > +	S5M8767_DVS_BUCK_RAMP_50	= 0xe,
> > +	S5M8767_DVS_BUCK_RAMP_100	= 0xf,
> > +};
> 
> Why do these have to be enums?

There is no special need. I chose enum because it is a kind of
enumeration of all valid values for BUCK_RAMP field (valid according to
datasheet). If you prefer #define then I'll change it.


Best regards,
Krzysztof


