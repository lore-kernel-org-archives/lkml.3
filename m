Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaBEKsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:48:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12258 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaBEKsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:48:20 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-17-52f216f29ee5
Message-id: <1391597296.3726.13.camel@AMDC1943>
Subject: Re: [PATCH 08/18] mfd: max14577: Rename state container to maxim_core
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Wed, 05 Feb 2014 11:48:16 +0100
In-reply-to: <20140203094258.GI13529@lee--X1>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-9-git-send-email-k.kozlowski@samsung.com>
 <20140203094258.GI13529@lee--X1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xa7qfxD4FGXT9FbGY+vAJm8X1L89Z
	LSY9ec9sMXHlZGaLs01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2ax9shddovbjSvYLE53szrw
	eOycdZfdY/MKLY9NqzrZPO5c28PmMe9koMfmJfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fA
	lbF18hymgktcFSuvzGFpYJzJ0cXIySEhYCKxf/txJghbTOLCvfVsXYxcHEICSxklHnXdZYdw
	PjNKvJ88hQWkildAX+Ld1lusILawgJ/EyZetYN1sAsYSm5cvAesWEVjCKPHkzXpGkASzwB4m
	idV75EFsFgFVick/9oEN4hTQlfj7bQPUuhWMEpsOL2eDaFCXmDRvETPETUoSu9s72SHi8hKb
	17xlhrhCUOLH5HssExgFZiFpmYWkbBaSsgWMzKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcx
	QmLm6w7GpcesDjEKcDAq8fAaCH8MEmJNLCuuzD3EKMHBrCTC2yjwKUiINyWxsiq1KD++qDQn
	tfgQIxMHp1QDo+iT1qmTFizbKRjw8HL+TKWyKT6TQrrfRhp5H7zz0uV8nvGDb51Nvz9sjD4k
	rM+fN8v4mE2s8rrb7+N+2cizzkmXXt/1xrX07aNAsa3SqVHGBzzaj4h5f/2znSX3yuczM1g0
	xWYFv5u90fX+9gtcSwXWlYUe75y3S7Eh+P9C2c7697YXXu2eq67EUpyRaKjFXFScCAAWe8qj
	dwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Cc: Chanwoo, Mark and Dmitry for ACK-s on their subsystems.

Krzysztof Kozlowski

On Mon, 2014-02-03 at 09:42 +0000, Lee Jones wrote:
> > This patch continues the preparation for adding support for max77836
> > device to existing max14577 driver.
> > 
> > The patch renames the struct "max14577" state container to "maxim_core".
> > This is only a rename-like patch, new code is not added.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/extcon/extcon-max14577.c     |   22 +++++------
> >  drivers/mfd/max14577.c               |   68 +++++++++++++++++-----------------
> >  drivers/power/max14577_charger.c     |   16 ++++----
> >  drivers/regulator/max14577.c         |    6 +--
> >  include/linux/mfd/max14577-private.h |    5 ++-
> >  5 files changed, 60 insertions(+), 57 deletions(-)
> 
> Need some more maintainer Acks here.
> 
> > -struct max14577 {
> > +/*
> > + * State container for max14577-like drivers.
> > + */
> 
> I don't think this comment is required.
> 
> Besides that, the code looks fine:
>   Acked-by: Lee Jones <lee.jones@linaro.org>
> 
> > +struct maxim_core {
> >  	struct device *dev;
> >  	struct i2c_client *i2c; /* Slave addr = 0x4A */
> >  
> 

