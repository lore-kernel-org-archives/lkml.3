Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaCRJvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 05:51:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44596 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbaCRJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 05:51:07 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-40-53281709868e
Message-id: <53281709.5010102@samsung.com>
Date: Tue, 18 Mar 2014 18:51:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 1/4] mfd: max8997: use regmap to access registers
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-2-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1394703532-494-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWyRsSkRJdTXCPY4MApdYslF6+yW0x9+ITN
	4ujOiUwWk568Z7Y4vOgFo8XElZOZLV6/MLS4//Uoo8W3Kx1MFjc/fWO1uLxrDpvF1jfrGC3W
	HrnLbnG7cQWbxbW9x5ktHhzeyW6xe9dTVov9nR2MFqe7WR2EPXbOusvusWfiSTaPzSu0PDat
	6mTzuHNtD5vHvJOBHnvm/2D16NuyitFj+ryfTB6fN8l5rN+ylSmAO4rLJiU1J7MstUjfLoEr
	48uc6SwFLzkq/k99z9rA+Jyti5GTQ0LARGL3mtVMELaYxIV764HiXBxCAksZJVY+2MkIU/R8
	/ndmiMQiRon227ugql4xStzYOwFsFK+AlsTih5dZuhg5OFgEVCXmzw4FCbMBhfe/uAFWIioQ
	JrFy+hUWiHJBiR+T74HZIkA1dz7OZwexmQWOMku8b5ADsYUFPCQatm9jBbGFBGolptxfxQQy
	nlPAReLVOQ+Ich2J/a3T2CBseYnNa96C3SkhcIJD4tv0PrD5LAICEt8mHwI7TUJAVmLTAWaI
	vyQlDq64wTKBUWwWkotmIRk7C8nYBYzMqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECE8Tp
	f896dzDePmB9iDEZaOVEZinR5HxggskriTc0NjOyMDUxNTYytzQjTVhJnDfpYVKQkEB6Yklq
	dmpqQWpRfFFpTmrxIUYmDk6pBkbVXU/FmeY6pB9fzV2xarbJ6VXxpUuulv3jM1/tppmpcjej
	beoKjXxerQpe5WTp9qly8nvsv2lPUSqYIq2ataA2J6FPPP2k1+XkD9Oe+io2nkhcc/H6iQOM
	c/MtCn9tVGuayHPgVHdb7wZmvaMRh4//Wyhybt/b3fF185wEVwhuF5a4wlxatkKJpTgj0VCL
	uag4EQBeIxbCJgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t9jAV1OcY1ggw3b5CyWXLzKbjH14RM2
	i6M7JzJZTHryntni8KIXjBYTV05mtnj9wtDi/tejjBbfrnQwWdz89I3V4vKuOWwWW9+sY7RY
	e+Quu8XtxhVsFtf2Hme2eHB4J7vF7l1PWS32d3YwWpzuZnUQ9tg56y67x56JJ9k8Nq/Q8ti0
	qpPN4861PWwe804GeuyZ/4PVo2/LKkaP6fN+Mnl83iTnsX7LVqYA7qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoO+UFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBlf5kxnKXjJUfF/6nvWBsbnbF2MnBwSAiYSz+d/Z4aw
	xSQu3FsPFOfiEBJYxCjRfnsXlPOKUeLG3glgHbwCWhKLH15m6WLk4GARUJWYPzsUJMwGFN7/
	4gZYiahAmMTK6VdYIMoFJX5MvgdmiwDV3Pk4nx3EZhY4yizxvkEOxBYW8JBo2L6NFcQWEqiV
	mHJ/FRPIeE4BF4lX5zwgynUk9rdOY4Ow5SU2r3nLPIFRYBaSDbOQlM1CUraAkXkVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnD6eSa1g3Flg8UhRgEORiUe3hds6sFCrIllxZW5hxglOJiV
	RHhPiGgEC/GmJFZWpRblxxeV5qQWH2JMBvp/IrOUaHI+MDXmlcQbGpuYGVkamRtaGBmbkyas
	JM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjOnOrtdQZUeGj15eIhV+YK/Ij8Bfn1MfbooW9
	Mu1rAmYHrDmmENBUUNoZ0KTdqcFg+jtb8zLPH1b9vC5JZXf9NYasWf4x9+8k8l1yvfJraZ3D
	5dboNAU/gajmx21vmviZO/yXpk8NqY69U9TE4ix59JDGR8/7S7dJc/l58KSbvoxQ6Tw3RYml
	OCPRUIu5qDgRAPhXlsWDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 06:38 PM, Robert Baldyga wrote:
> This patch modifies max8997 driver and each associated function driver,
> to use regmap instead of operating directly on i2c bus. It will allow to
> simplify IRQ handling using regmap-irq.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/extcon/extcon-max8997.c     |   31 ++++----
>  drivers/input/misc/max8997_haptic.c |   34 +++++----
>  drivers/leds/leds-max8997.c         |   13 ++--
>  drivers/mfd/Kconfig                 |    1 +
>  drivers/mfd/max8997-irq.c           |   64 +++++++---------
>  drivers/mfd/max8997.c               |  141 ++++++++++++++++-------------------
>  drivers/power/max8997_charger.c     |   33 ++++----
>  drivers/regulator/max8997.c         |   87 +++++++++++----------
>  drivers/rtc/rtc-max8997.c           |   56 +++++++-------
>  include/linux/mfd/max8997-private.h |   17 ++---
>  10 files changed, 228 insertions(+), 249 deletions(-)
> 

For extcon part,
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi

