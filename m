Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaE3Lzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:55:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39182 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaE3Lzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:55:44 -0400
X-AuditID: cbfee68f-b7fef6d000003970-a2-538871bdfd55
Message-id: <538871BD.2030002@samsung.com>
Date: Fri, 30 May 2014 20:55:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: kgene.kim@samsung.com, t.figa@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, ben-linux@fluff.org, linux@arm.linux.org.uk,
        l.krishna@samsung.com, chanho61.park@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Add pmu sysreg node to Exynos3250
References: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
 <538870F8.9090507@gmail.com>
In-reply-to: <538870F8.9090507@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsWyRsSkSHdvYUewQfM/c4tJ6w4wWVzer20x
	/8g5Vov+NwtZLc69Wslo0bvgKpvF2aY37BY7t9xgs9j0+BqrxcK2JSwWl3fNYbOYcX4fk8Xt
	y7wWS69fZLKYMH0ti8XbO9NZLFr3HmG3WD/jNYvFql1/GB2EPdbMW8Po0dLcw+Zxua+XyePv
	qhfMHjtn3WX3WLn8C5vH5hVaHptWdQIZS+o9+rasYvT4vEkugDuKyyYlNSezLLVI3y6BK+PW
	vCbmgmbWip1bvjI3MDaxdDFyckgImEjMe/qRGcIWk7hwbz1bFyMXh5DAUkaJzuvz4YrudLSw
	QiQWMUq0bOpnh3BeM0r8e7WACaSKV0BL4sPLt0CjODhYBFQlvrWUgITZgML7X9xgA7FFBcIk
	Vk6/wgJRLijxY/I9MFtEQF3i2xSImcwCt5kl5p8+zwqSEBZwkOjZDHGFkECKxK3rl8B2cQpo
	SryevxnsbGYBHYn9rdPYIGx5ic1rQG7gArr6AofErx3tYEUsAgIS3yYfYgE5TkJAVmLTAaiX
	JSUOrrjBMoFRbBaSm2YhGTsLydgFjMyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MQKTxOl/
	z/p3MN49YH2IMRlo5URmKdHkfGCSySuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs
	1NSC1KL4otKc1OJDjEwcnFINjHzTjs49Vv2qeoPTqj8z/+xryBWbNz3izrRMjchg9oaU7IZD
	LWZyTy/8/TRtetzxpHLuO3sXhfycytoc5PKN13+WbvuB63G9yVw6P2Z5rr6xrGyBEmvLk7xu
	R4brzc8knzfPUisv3fvjXtbO88KRteuisg/U2qX4XW6arsly/9LnDleVhzd79ZRYijMSDbWY
	i4oTATOU378oAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEKsWRmVeSWpSXmKPExsVy+t9jAd29hR3BBme79S0mrTvAZHF5v7bF
	/CPnWC363yxktTj3aiWjRe+Cq2wWZ5vesFvs3HKDzWLT42usFgvblrBYXN41h81ixvl9TBa3
	L/NaLL1+kcliwvS1LBZv70xnsWjde4TdYv2M1ywWq3b9YXQQ9lgzbw2jR0tzD5vH5b5eJo+/
	q14we+ycdZfdY+XyL2wem1doeWxa1QlkLKn36NuyitHj8ya5AO6oBkabjNTElNQihdS85PyU
	zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDvlBTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGENYwZt+Y1MRc0s1bs3PKVuYGxiaWLkZNDQsBE4k5HCyuELSZx
	4d56ti5GLg4hgUWMEi2b+tkhnNeMEv9eLWACqeIV0JL48PItcxcjBweLgKrEt5YSkDAbUHj/
	ixtsILaoQJjEyulXWCDKBSV+TL4HZosIqEt8mwIxk1ngNrPE/NPnwTYLCzhI9GyeD1YkJJAi
	cev6JbBdnAKaEq/nb2YGsZkFdCT2t05jg7DlJTavecs8gVFgFpIds5CUzUJStoCReRWjaGpB
	ckFxUnqukV5xYm5xaV66XnJ+7iZGcAp6Jr2DcVWDxSFGAQ5GJR7eCentwUKsiWXFlbmHGCU4
	mJVEeI/HdwQL8aYkVlalFuXHF5XmpBYfYkwGhsBEZinR5HxgeswriTc0NjEzsjQyN7QwMjYn
	TVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbVgquXc83ekd9WJ9zXrXP/yrkIu7hf2vfd
	t65jtjh5N8xvdpzTR55uxYLWPO60b2p3rVLyflgUHRE3CYhQuDPbg2mL6/2Vy8/1PmJ6nPuo
	NzW88Hn1znzfpyGrZ8+L27uh5zLL28SLSRe6Zi1w99oxQchG28AlqeiuTc8ETZ3qQ5rGvD8e
	7VViKc5INNRiLipOBAAbntdEhQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 08:52 PM, Tomasz Figa wrote:
> On 26.05.2014 08:29, Chanwoo Choi wrote:
>> This patch add pmusysreg node for Exynos3250 to access PMU (Power Management Unit)
>> register in a centralized way using syscon driver.
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
>>  arch/arm/boot/dts/exynos3250.dtsi                     | 5 +++++
>>  2 files changed, 6 insertions(+)
> 
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 

Thanks for your review.

Best Regards,
Chanwoo Choi

