Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaKRId2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:33:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33057 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaKRIdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:33:23 -0500
X-AuditID: cbfee691-f79b86d000004a5a-4a-546b043e2c3b
Message-id: <546B043E.5040000@samsung.com>
Date: Tue, 18 Nov 2014 17:33:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: sec-core: Add support for S2MPS13 device
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
 <20141118082207.GU24004@x1>
In-reply-to: <20141118082207.GU24004@x1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkUNeOJTvE4P0Ka4slF6+yW0x9+ITN
	Yv6Rc6wWfya0sllMuj+BxeJs0xt2i/tfjzJafLvSwWRxedccNounEy6yWZzuZrW4uOILkwOP
	x85Zd9k9Nq3qZPO4c20Pm8e8k4EefVtWMXpMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujCk3
	XzEWnOSpmP+gh7GB8RlnFyMnh4SAicS0W89ZIWwxiQv31rN1MXJxCAksZZSYtuAnG0zRnK0L
	mSASixglrly7zQzhvGaU+DHtK1gVr4CWROvbc4xdjBwcLAKqEnv7dUHCbEDh/S9ugJWICoRJ
	rJx+hQWiXFDix+R7LCDlIgIqEufemIOMZBboY5L43fOAHaRGWMBNYu6Li1C7ZjNKPHz7GuxU
	TgENiTftB5lAbGYBdYlJ8xYxQ9jyEpvXvAVrkBBo5JDY1HmXESTBIiAg8W3yIbBtEgKyEpsO
	MEN8JilxcMUNlgmMYrOQ3DQLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREY
	u6f/PZu4g/H+AetDjAIcjEo8vAlTs0KEWBPLiitzDzGaAl0xkVlKNDkfmCDySuINjc2MLExN
	TI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg7P+2492O+tsF/hZmh/gs
	DTtZk8rXvbD/ErRsipvpJZGMuVfVjJ4F/gheHx27ou23jcyWwNLMwlff+9oWNGZGdsry/HOf
	JfY+fbYn4wp9fgmJ9TUbe0L/PNpzeIdXrcYJv08FD5pqL29ty64+OE/9/JFXFtPjD3/eHvPo
	o2656zmhR/y1ZudklFiKMxINtZiLihMBo+wmvtgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgK4dS3aIwd43JhZLLl5lt5j68Amb
	xfwj51gt/kxoZbOYdH8Ci8XZpjfsFve/HmW0+Halg8ni8q45bBZPJ1xkszjdzWpxccUXJgce
	j52z7rJ7bFrVyeZx59oeNo95JwM9+rasYvSYPu8nk8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIcqKZQl5pQChQISi4uV9O0wTQgN
	cdO1gGmM0PUNCYLrMTJAAwlrGDOm3HzFWHCSp2L+gx7GBsZnnF2MnBwSAiYSc7YuZIKwxSQu
	3FvP1sXIxSEksIhR4sq128wQzmtGiR/TvrKBVPEKaEm0vj3H2MXIwcEioCqxt18XJMwGFN7/
	4gZYiahAmMTK6VdYIMoFJX5MvscCUi4ioCJx7o05yEhmgT4mid89D9hBaoQF3CTmvrgItWs2
	o8TDt69ZQRKcAhoSb9oPgl3HLKAuMWneImYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqm
	FiQXFCel5xrqFSfmFpfmpesl5+duYgQnhmdSOxhXNlgcYhTgYFTi4U2YmhUixJpYVlyZe4hR
	goNZSYT3XDdQiDclsbIqtSg/vqg0J7X4EKMpMAQmMkuJJucDk1ZeSbyhsYmZkaWRuaGFkbG5
	kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQZG2wa/c+YLWy/1HGQ9+eTUfo2sT9Z9i8/HTdk4
	K2GFXr3ka87HrL0VNz8uUD7LvaD+bbJy0yM2rc0x88TyjZ8kzpv/6/sZi2MN9fEn98yavHZK
	uMmzV6xZX06t/fwv/VabV6ELA5+nb4zDh975SQGcx0qCD7IGrv938scHF1/VRbGbGi3tO/UL
	lViKMxINtZiLihMB7QHMtCIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee,

On 11/18/2014 05:22 PM, Lee Jones wrote:
> On Mon, 17 Nov 2014, Chanwoo Choi wrote:
> 
>> This patch adds the support for Samsung S2MPS13 PMIC device to the sec-core MFD
>> driver. The S2MPS13 is very similar with existing S2MPS14 and includes PMIC/
>> RTC/CLOCK devices.
>>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/mfd/sec-core.c           | 18 ++++++++++++++++++
>>  drivers/mfd/sec-irq.c            | 23 +++++++++++++++++------
>>  include/linux/mfd/samsung/core.h |  1 +
>>  3 files changed, 36 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index 5993608..48c0d4a 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -73,6 +73,17 @@ static const struct mfd_cell s2mps11_devs[] = {
>>  	}
>>  };
>>  
>> +static const struct mfd_cell s2mps13_devs[] = {
>> +	{
>> +		.name = "s2mps13-pmic",
>> +	}, {
>> +		.name = "s2mps13-rtc",
>> +	}, {
>> +		.name = "s2mps13-clk",
>> +		.of_compatible = "samsung,s2mps13-clk",
>> +	}
>> +};
> 
> If you have to resubmit this for any reason, I'd like the one liners
> on one single line (curly braces and all).

OK, I'll modify it as following:

static const struct mfd_cell s2mps13_devs[] = {
	{ .name = "s2mps13-pmic", },
	{ .name = "s2mps13-rtc", },
	{
		.name = "s2mps13-clk",
		.of_compatible = "samsung,s2mps13-clk",
	},
};

Best Regards,
Chanwoo Choi

> 
> But for now, for my reference:
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>




