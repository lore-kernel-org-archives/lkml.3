Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBLPAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:00:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31148 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaBLPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:00:52 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-36-52fb8ca253ec
Message-id: <1392217248.22265.28.camel@AMDC1943>
Subject: Re: [PATCH 07/14] regulator: s2mps11: Choose number of supported
 regulators during probe
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Date: Wed, 12 Feb 2014 16:00:48 +0100
In-reply-to: <CAKew6eV4t-CybRe0h3jVTFH5xZvj5+XLVTKdNyWyYNby_jMnZQ@mail.gmail.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
 <1392123837-5517-8-git-send-email-k.kozlowski@samsung.com>
 <CAKew6eV4t-CybRe0h3jVTFH5xZvj5+XLVTKdNyWyYNby_jMnZQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xK7qLen4HGbxfJWixccZ6VoupD5+w
	WVz/8pzV4mzTG3aL+1+PMlp8u9LBZHF51xw2ixnn9zFZrD1yl93idDerxcUVX5gs5v5uZHXg
	8dg56y67x6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDL2/zrPVLCG
	paL1dwd7A+Nk5i5GDg4JAROJtsNOXYycQKaYxIV769m6GLk4hASWMkqcnd7DDOF8ZpSY0nKJ
	EaSKV8BAYv/CZUwgtrBAssS9cwfBbDYBY4nNy5ewgdgiQDUTl8xjBbGZBW4xS6y9bAayjEVA
	VeLbslyQMKdAsMSzm8tYIeafYpT4tvoUM0S9usSkeYuYIS5Sktjd3skOEZeX2LzmLTPEDYIS
	PybfY5nAKDALScssJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESHV93MC49
	ZnWIUYCDUYmHl8HzV5AQa2JZcWXuIUYJDmYlEV6j5t9BQrwpiZVVqUX58UWlOanFhxiZODil
	GhgX7m9ao61444jhVeu539VVzGzWeM6NXdCytmSNq97a3//qWXc7rsk8VzhfxMFZ9Xt45G2P
	s2Jf/N3Olmb5HD0v61xq2rHnE9u17lvzlXoOV1/bIL48l7ny6CplSUanOVYBJrX6Oa4zXhyd
	9HpJT6zaTbtN9h9lz1m+rn58wND88o/d3hcYlyoqsRRnJBpqMRcVJwIA68J/A2wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 15:31 +0530, Yadwinder Singh Brar wrote:
> Hi,
> 
> 
> >
> > +       dev_type = platform_get_device_id(pdev)->driver_data;
> > +       switch (dev_type) {
> > +       case S2MPS11X:
> > +               s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
> > +               regulators = s2mps11_regulators;
> 
> How about creating and passing copy of s2mps11_regulators at runtime
> and making s2mps11_regulators __initdata ?

Sounds good, I'll add this in next version of patchset.


Best regards,
Krzysztof



