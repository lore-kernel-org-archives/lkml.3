Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaBEKsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:48:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55741 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaBEKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:48:17 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-0d-52f216ef63aa
Message-id: <1391597294.3726.12.camel@AMDC1943>
Subject: Re: [PATCH 09/18] mfd: max14577: Add "muic" suffix to regmap and
 irq_chip
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, LeeJones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 11:48:14 +0100
In-reply-to: <20140203094518.GJ13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-10-git-send-email-k.kozlowski@samsung.com>
 <20140203094518.GJ13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xa7rvxT4FGdw6rWcx9eETNovrX56z
	Wkx68p7ZYuLKycwWZ5vesFvc/3qU0eLblQ4mi02Pr7FaXN41h81i7ZG77Ba3G1ewWZzuZnXg
	8dg56y67x+YVWh6bVnWyedy5tofNY97JQI/NS+o9+rasYvT4vEkugCOKyyYlNSezLLVI3y6B
	K+PU7iPMBSc5KrqPfWFtYLzN1sXIwSEhYCLR3FLSxcgJZIpJXLi3HijMxSEksJRR4snlZnYI
	5zOjxN1JX5hAqngF9CWerz7PBmILC4RILHvfzAhiswkYS2xevgQsLiKwhFHi5ylvkGZmgd1M
	EjunPwJrZhFQlehZfY4dZDOngK7E9vdSEAtWMkr8nXINbBCzgLrEpHmLmCFOUpLY3d7JDhGX
	l9i85i0zxBGCEj8m32OZwCgwC0nLLCRls5CULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yf
	u4kREi9fdzAuPWZ1iFGAg1GJh9dA+GOQEGtiWXFl7iFGCQ5mJRHeRoFPQUK8KYmVValF+fFF
	pTmpxYcYmTg4pRoYF8qfLVc5dcWysYxL4m5/s4qE3KzTa7J7O6xWbLw8U0L+1Mtco6srqvY/
	sOxz+Wn4pdlX75DKjsi6t11JS70cG6TOvrmlfGCd+vq2NycVvnvdjHpbW7uv4c+WnAfZ+Xv/
	tJ7lj29mSrB8K/KkhdWcp8nsrVjNiWz/G3J7prYeP9/0+lbTScUdSizFGYmGWsxFxYkAXBBT
	OHUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Cc: Chanwoo, Mark and Dmitry for ACK-s on their subsystems.

Krzysztof Kozlowski

On Mon, 2014-02-03 at 09:45 +0000, Lee Jones wrote:
> > This patch continues the preparation for adding support for max77836
> > device to existing max14577 driver.
> > 
> > Add "muic" suffix to regmap and irq_data fields in maxim_core state
> > container to prepare for max77836 support.
> > This is only a rename-like patch, new code is not added.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/extcon/extcon-max14577.c     |   17 +++++++++--------
> >  drivers/mfd/max14577.c               |   22 +++++++++++-----------
> >  drivers/power/max14577_charger.c     |    8 ++++----
> >  drivers/regulator/max14577.c         |    2 +-
> >  include/linux/mfd/max14577-private.h |    4 ++--
> >  5 files changed, 27 insertions(+), 26 deletions(-)
> 
> Happy to apply this with maintainer Acks.
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 

