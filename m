Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaKXJAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:00:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59277 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaKXJAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:00:53 -0500
X-AuditID: cbfee691-f79b86d000004a5a-4b-5472f3c3b66e
Message-id: <5472F3C2.4030907@samsung.com>
Date: Mon, 24 Nov 2014 18:00:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: Mike Turquette <mturquette@linaro.org>, broonie@kernel.org,
        a.zummo@towertech.it, lgirdwood@gmail.com, sbkim73@samsung.com,
        sameo@linux.intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/5] clk: s2mps11: Add the support for S2MPS13 PMIC clock
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
 <1416301183-10478-4-git-send-email-cw00.choi@samsung.com>
 <20141118215926.25314.90810@quantum> <20141119164310.GH1875@x1>
In-reply-to: <20141119164310.GH1875@x1>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkSPfw56IQg+2LpSyWXLzKbjH14RM2
	i/lHzrFa/JnQymYx6f4EFovXLwwtzja9Ybe4//Uoo8W3Kx1MFpd3zWGzeDrhIpvF6W5Wi4sr
	vjA58HrsnHWX3WPTqk42jzvX9rB5zDsZ6NG3ZRWjx/R5P5k8Pm+SC2CP4rJJSc3JLEst0rdL
	4Mroe3WKvaBFquJX9xLWBsYJwl2MnBwSAiYSd39sYYewxSQu3FvP1sXIxSEksJRR4uXs88ww
	Re8m9zJDJKYzSvxe+YIJwnnNKPF0YisrSBWvgJbE36nNTCA2i4CqxKvT91lAbDag+P4XN9hA
	bFGBMImV06+wQNQLSvyYfA/I5uAQEVCROPfGHGQms8AuJon775+DbRYW8JfYd24t1EmHGSV2
	TjwA1swpoC7x91A/2DJmIHvSvEXMELa8xOY1b8FOlRBo5ZA4vOMQK8RFAhLfJh8C2yYhICux
	6QDUa5ISB1fcYJnAKDYLyU2zkIydhWTsAkbmVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB
	UXz637OJOxjvH7A+xCjAwajEwztjfVGIEGtiWXFl7iFGU6ArJjJLiSbnA1NFXkm8obGZkYWp
	iamxkbmlmZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjA53L5nEZpVnxDvObnXd
	wXMyTywzWE1w6p2FHf4TrDdedLIX3j17XtKkR0xWL34LXLk7eXnXdvZt9tnFn1KjylKmMQfH
	HFT0l7rNE/FVf+oLdac56reTZkyL806Yr/DbWlT9/LFLSps3VgafSWxeaHaQtaspP2NjHPvh
	D9u3hmbYCLH8vTPbXomlOCPRUIu5qDgRAAglCyzdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd3Dn4tCDP7PEbRYcvEqu8XUh0/Y
	LOYfOcdq8WdCK5vFpPsTWCxevzC0ONv0ht3i/tejjBbfrnQwWVzeNYfN4umEi2wWp7tZLS6u
	+MLkwOuxc9Zddo9NqzrZPO5c28PmMe9koEffllWMHtPn/WTy+LxJLoA9qoHRJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoWCWFssScUqBQQGJxsZK+
	HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRt+rU+wFLVIVv7qXsDYwThDuYuTkkBAwkXg3uZcZ
	whaTuHBvPVsXIxeHkMB0RonfK18wQTivGSWeTmxlBaniFdCS+Du1mQnEZhFQlXh1+j4LiM0G
	FN//4gYbiC0qECaxcvoVFoh6QYkfk+8B2RwcIgIqEufemIPMZBbYxSRx//1zsM3CAv4S+86t
	hdp8mFFi58QDYM2cAuoSfw/1gy1jBrInzVvEDGHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4BTxTHoH46oGi0OMAhyMSjy8M9YXhQixJpYVV+Ye
	YpTgYFYS4T37rzBEiDclsbIqtSg/vqg0J7X4EKMpMAgmMkuJJucD01deSbyhsYmZkaWRuaGF
	kbG5kjjvjZu5IUIC6YklqdmpqQWpRTB9TBycUg2MXrxLV51QWrpyyr4jfxYH1bVODCxn2+q2
	YW2+l4f8kd7bkmHXBSR3imuc22ic/+DOnz9/Ps0Sv8ZqVHem8s2M8MT7ygZyy3iCXNiy7/de
	4qrf7SBk1N5Y+6Tt5cyrXS+evoqwudsfrJ6jM4V9MqczQ9LcHu+bx3Rmu+R7291tbFC+LXFu
	+aYOJZbijERDLeai4kQAnOTL+ycDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee,

Could you please apply this patchset on your tree
or Do we wait the Ack from RTC mainatiner for patch 4?

Best Regards,
Chanwoo Choi

On 11/20/2014 01:43 AM, Lee Jones wrote:
> On Tue, 18 Nov 2014, Mike Turquette wrote:
> 
>> Quoting Chanwoo Choi (2014-11-18 00:59:41)
>>> This patch adds the support for S2MPS13 PMIC clock which is same with existing
>>> S2MPS14 RTC IP. But, S2MPS13 uses all of clocks (32khz_{ap|bt|cp}).
>>>
>>> Cc: Mike Turquette <mturquette@linaro.org>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
>>
>> Applied to clk-next.
> 
> I'm pretty sure you can't do that.  You have a dependency on
> linux/mfd/samsung/s2mps13.h, which is satisfied in one of the earlier
> patches in the set.  If you'd care to just provide an Ack for this
> patch, I can send you a pull-request with the decencies met.
> 
>>> ---
>>>  drivers/clk/clk-s2mps11.c | 24 ++++++++++++++++++++++++
>>>  1 file changed, 24 insertions(+)
>>>
>>> diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
>>> index b7797fb..7bb13af 100644
>>> --- a/drivers/clk/clk-s2mps11.c
>>> +++ b/drivers/clk/clk-s2mps11.c
>>> @@ -23,6 +23,7 @@
>>>  #include <linux/clk-provider.h>
>>>  #include <linux/platform_device.h>
>>>  #include <linux/mfd/samsung/s2mps11.h>
>>> +#include <linux/mfd/samsung/s2mps13.h>
>>>  #include <linux/mfd/samsung/s2mps14.h>
>>>  #include <linux/mfd/samsung/s5m8767.h>
>>>  #include <linux/mfd/samsung/core.h>
>>> @@ -120,6 +121,24 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
>>>         },
>>>  };
>>>  
>>> +static struct clk_init_data s2mps13_clks_init[S2MPS11_CLKS_NUM] = {
>>> +       [S2MPS11_CLK_AP] = {
>>> +               .name = "s2mps13_ap",
>>> +               .ops = &s2mps11_clk_ops,
>>> +               .flags = CLK_IS_ROOT,
>>> +       },
>>> +       [S2MPS11_CLK_CP] = {
>>> +               .name = "s2mps13_cp",
>>> +               .ops = &s2mps11_clk_ops,
>>> +               .flags = CLK_IS_ROOT,
>>> +       },
>>> +       [S2MPS11_CLK_BT] = {
>>> +               .name = "s2mps13_bt",
>>> +               .ops = &s2mps11_clk_ops,
>>> +               .flags = CLK_IS_ROOT,
>>> +       },
>>> +};
>>> +
>>>  static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
>>>         [S2MPS11_CLK_AP] = {
>>>                 .name = "s2mps14_ap",
>>> @@ -184,6 +203,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
>>>                 s2mps11_reg = S2MPS11_REG_RTC_CTRL;
>>>                 clks_init = s2mps11_clks_init;
>>>                 break;
>>> +       case S2MPS13X:
>>> +               s2mps11_reg = S2MPS13_REG_RTCCTRL;
>>> +               clks_init = s2mps13_clks_init;
>>> +               break;
>>>         case S2MPS14X:
>>>                 s2mps11_reg = S2MPS14_REG_RTCCTRL;
>>>                 clks_init = s2mps14_clks_init;
>>> @@ -279,6 +302,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
>>>  
>>>  static const struct platform_device_id s2mps11_clk_id[] = {
>>>         { "s2mps11-clk", S2MPS11X},
>>> +       { "s2mps13-clk", S2MPS13X},
>>>         { "s2mps14-clk", S2MPS14X},
>>>         { "s5m8767-clk", S5M8767X},
>>>         { },
> 

