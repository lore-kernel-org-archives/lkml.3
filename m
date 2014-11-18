Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaKRBGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:06:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:45460 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaKRBGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:06:46 -0500
X-AuditID: cbfee691-f79b86d000004a5a-9b-546a9ba1eb2f
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <546A9BA0.2080406@samsung.com>
Date: Tue, 18 Nov 2014 10:06:40 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
Cc: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sbkim73@samsung.com,
        sameo@linux.intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-4-git-send-email-cw00.choi@samsung.com>
 <5469CAF9.6020700@samsung.com>
In-reply-to: <5469CAF9.6020700@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWyRsSkWHfh7KwQg1Mb1SyWXLzKbjH14RM2
	i/lHzrFa/JnQymYx6f4EFovXLwwtzja9Ybe4//Uoo8W3Kx1MFpd3zWGzeDrhIpvF6W5Wi4sr
	vjA58HrsnHWX3WPTqk42jzvX9rB5zDsZ6NG3ZRWjx/R5P5k8Pm+SC2CP4rJJSc3JLEst0rdL
	4MrYv+cSS8Fa0YqLfzeyNDAuF+xi5OSQEDCRWHDxMSOELSZx4d56ti5GLg4hgaWMEtPmwSRM
	JC4v3wKVmM4osenQRbAEr4CgxI/J91hAbGYBdYlJ8xYxQ9giElueHIWKa0ssW/iaGaL5NaNE
	y42V7BDNWhIL9u8Hs1kEVCVWb57MBGKzAcX3v7jBBmKLCoRJrJx+BWyQiICbxOmLq5lABjEL
	LGOSOHL2FVhCWMBX4uGZE0wQG+YxSvQ+nsbaxcjBwQm0uv25CUhcQqCTQ+LaowZGiG0CEt8m
	H2IBqZEQkJXYdIAZ4k1JiYMrbrBMYBSfheS5WUiem4XkuVlInlvAyLKKUTS1ILmgOCm9yFSv
	ODG3uDQvXS85P3cTIzDqT/97NnEH4/0D1ocYBTgYlXh4E6ZmhQixJpYVV+YeYjQFumgis5Ro
	cj4wteSVxBsamxlZmJqYGhuZW5opifPqSP8MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4
	6faxg2e9+WTe2qwLS39/6+o99Sm7S/a1WX1iYt3YmvZngmd/uatmZmv+oaq1Brzb1YOX33T6
	cLf7R0lFrsOOntV1Ga65f5wELpc+clzatPKWwNK883nSIkXsLUIpC1abcgV0HPwfeNBKRkGh
	6WNiyHeN5tIak+6FN5yPSGua1j5VZ97Es1uJpTgj0VCLuag4EQAfPH8d9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd2Fs7NCDCZNlLVYcvEqu8XUh0/Y
	LOYfOcdq8WdCK5vFpPsTWCxevzC0ONv0ht3i/tejjBbfrnQwWVzeNYfN4umEi2wWp7tZLS6u
	+MLkwOuxc9Zddo9NqzrZPO5c28PmMe9koEffllWMHtPn/WTy+LxJLoA9qoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoWCWFssScUqBQQGJxsZK+
	HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxoQbi9gLvotUbFw4la2B8aNAFyMnh4SAicTl5VvY
	IGwxiQv31gPZXBxCAtMZJTYdusgIkuAVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPU
	v2aUaLmxkh2iXktiwf79YDaLgKrE6s2TmUBsNqD4/hc3wJaJCoRJrJx+hQXEFhFwkzh9cTUT
	yCBmgWVMEkfOvgJLCAv4Sjw8c4IJYsM8Ronex9NYQa7gFNCWaH9uMoFRYBaS+2Yh3DcLyX0L
	GJlXMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnh2dSOxhXNlgcYhTgYFTi4U2YmhUixJpY
	VlyZe4hRgoNZSYT3XDdQiDclsbIqtSg/vqg0J7X4EKMp0HcTmaVEk/OBqSuvJN7Q2MTMyNLI
	3NDCyNhcSZz3QKt1oJBAemJJanZqakFqEUwfEwenVAPj+Ujufl+PmCWaodpi8h87zygzPP2j
	9dbk4mu+uctT5MJPKTWv9wg6GiUVFh8TF3Y7dEFwzQTF6FrJ5b6/6zbukbG/apPbc2XtqoRf
	U/ZNmiKg2VFactzh0cPJb66FbE3nlt/gf0F5btH35emXs5YV75bz5Gjb7Rd///lmSefnNn/d
	ri54t4NPiaU4I9FQi7moOBEAvcOE7yUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2014 07:16 PM, Krzysztof Kozłowski wrote:
> On 17.11.2014 01:42, Chanwoo Choi wrote:
>> This patch adds the support for S2MPS13 PMIC clock which is same with existing
>> S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).
>>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>  drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
>> index b7797fb..7bb13af 100644
>> --- a/drivers/clk/clk-s2mps11.c
>> +++ b/drivers/clk/clk-s2mps11.c
>> @@ -23,6 +23,7 @@
>>  #include <linux/clk-provider.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/mfd/samsung/s2mps11.h>
>> +#include <linux/mfd/samsung/s2mps13.h>
>>  #include <linux/mfd/samsung/s2mps14.h>
>>  #include <linux/mfd/samsung/s5m8767.h>
>>  #include <linux/mfd/samsung/core.h>
>> @@ -120,6 +121,24 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
>>  	},
>>  };
>>  
>> +static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
>> +	[S2MPS11_CLK_AP] = {
>> +		.name = "s2mps13_ap",
>> +		.ops = &s2mps11_clk_ops,
>> +		.flags = CLK_IS_ROOT,
>> +	},
>> +	[S2MPS11_CLK_CP] = {
>> +		.name = "s2mps13_cp",
>> +		.ops = &s2mps11_clk_ops,
>> 		.flags = CLK_IS_ROOT,
> 
> The patch looks corrupted here. Missing '+'?

You are right. It is my mistake.
I will fix it.

> 
> Rest looks fine.
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi


> 
> Best regards,
> Krzysztof
> 
> 
>> +	},
>> +	[S2MPS11_CLK_BT] = {
>> +		.name = "s2mps13_bt",
>> +		.ops = &s2mps11_clk_ops,
>> +		.flags = CLK_IS_ROOT,
>> +	},
>> +};
>> +
>>  static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
>>  	[S2MPS11_CLK_AP] = {
>>  		.name = "s2mps14_ap",
>> @@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>>  		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
>>  		clks_init = s2mps11_clks_init;
>>  		break;
>> +	case S2MPS13X:
>> +		s2mps11_reg = S2MPS13_REG_RTCCTRL;
>> +		clks_init = s2mps13_clks_init;
>> +		break;
>>  	case S2MPS14X:
>>  		s2mps11_reg = S2MPS14_REG_RTCCTRL;
>>  		clks_init = s2mps14_clks_init;
>> @@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
>>  
>>  static const struct platform_device_id s2mps11_clk_id[] = {
>>  	{ "s2mps11-clk", S2MPS11X},
>> +	{ "s2mps13-clk", S2MPS13X},
>>  	{ "s2mps14-clk", S2MPS14X},
>>  	{ "s5m8767-clk", S5M8767X},
>>  	{ },
>>
> 
> 

