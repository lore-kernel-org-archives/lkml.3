Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3I3XOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:14:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47363 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3I3XOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:14:46 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-79-524a05df49ff
Message-id: <524A05DF.7070008@samsung.com>
Date: Tue, 01 Oct 2013 08:14:39 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: arizona: Get pdata from arizona structure not
 device
References: <1380378897-7164-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5248B9BA.9020003@samsung.com>
 <20130930095202.GY3635@opensource.wolfsonmicro.com>
 <524A0369.1080101@samsung.com>
In-reply-to: <524A0369.1080101@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWyRsSkUPc+q1eQwZWnIhZTHz5hs/g35Qa7
	xeVdc9gsbjeuYLNY/vY/mwOrx6ZVnWweLyf+ZvPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSu
	jM3XtAq+i1Zc+7+SsYHxtGAXIyeHhICJRM+6tcwQtpjEhXvr2boYuTiEBJYySmyZ+5wZpujy
	hf8sEIlFjBJzejdDOa8YJZ7tf8oKUsUroCXxpvMcO4jNIqAqsfrxW7A4G1B8/4sbbCC2qECY
	xMrpV1gg6gUlfky+B2aLCFhITFlyC2gbBwezQKnEj6XBIGFhgWCJdzt7mCB2nWGUuPHtJdhF
	nALaEm/e94PtYhbQkdjfOo0NwpaX2LzmLdTVu9gldj2DukdA4tvkQywg8yUEZCU2HYAqkZQ4
	uOIGywRGsVlILpqFZOosJFMXMDKvYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiMq9P/nvXv
	YLx7wPoQYzLQyonMUqLJ+cC4zCuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QD4+KCFZeKn+46MDG1yuPFrJPzN964pXgzyNH5uaSObodA2WX5vxtT
	FymcfSCz0EEmTDX70eF/7xzZMiwvqFdbrbv5/NO545HK807U2n85M7nGTabS1v7P9HpHKeki
	3zZ3fhuN+NaN9jtT5ZK1GSuNGXp1fm1qWOS0iJnz5K87Kz00H/zOW7spTomlOCPRUIu5qDgR
	AHEYdNrBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO59Vq8ggzOfeCymPnzCZvFvyg12
	i8u75rBZ3G5cwWax/O1/NgdWj02rOtk8Xk78zebRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBmbr2kVfBetuPZ/JWMD42nBLkZODgkBE4nLF/6zQNhi
	EhfurWfrYuTiEBJYxCgxp3czC4TzilHi2f6nrCBVvAJaEm86z7GD2CwCqhKrH78Fi7MBxfe/
	uMEGYosKhEmsnH6FBaJeUOLH5HtgtoiAhcSUJbeYuxg5OJgFSiV+LA0GCQsLBEu829nDBLHr
	DKPEjW8vmUESnALaEm/e94PtYhbQkdjfOo0NwpaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBcftMagfjygaLQ4wCHIxKPLwG9Z5BQqyJZcWVuYcY
	JTiYlUR4Ny8HCvGmJFZWpRblxxeV5qQWH2JMBobARGYp0eR8YErJK4k3NDYxM7I0Mje0MDI2
	J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGbtP3rNHvza2uzA8OyPv7pdlv8fMV4YmL
	hVKbWE5Wbz/joOqmtzLoBJNS7qubE//vOud35MQECxGJfY8D2Q8kfI/WlWb+smYb600VW0az
	a9+e24jzinwTUeM/ENgg+eRMcpkhl7bF4Yyc6xdSjYK2H/lZfi/2+xpx3Wq1Z7uD7y0wlrXy
	PH9TiaU4I9FQi7moOBEAjepdrR8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 08:04 AM, Chanwoo Choi wrote:
> On 09/30/2013 06:52 PM, Charles Keepax wrote:
>> On Mon, Sep 30, 2013 at 08:37:30AM +0900, Chanwoo Choi wrote:
>>> No, extcon-arizona driver don't currently support DT to get platform data.
>>> I cannot find some dt function to parse data from dts file.
>>> You have to implement extcon-arizona driver by using DT binding style
>>> to get platform data. I think this patch is not necessary.
>>
>> Currently the Arizona MFD driver reads the device tree
>> information and populates the pdata structure, this happens in
>> drivers/mfd/arizona-core.c. Then the various drivers just use the
>> pdata as normal.
>>
>> Admittedly, at the moment we don't parse any data for the extcon
>> driver but without this patch we will attempt to use a NULL
>> pointer on device tree systems.
>>
>> I would also be happy to implement this as a NULL check on the
>> pdata when we use it if that is preferable? But since we have the
>> cached pdata seems we might as well use it.
>>
> 
> I find below pdata list for extcon-arizona driver.
> But, drivers/mfd/arizona-core.c don't parse dt data for below pdata list
> of extcon-arizona. Did you test this patch for extcon-arizona operation?
> 
> arizona->pdata.micd_pol_gpio
> arizona->pdata.micd_force_micbias	
> arizona->pdata.hpdet_id_gpio
> arizona->pdata.hpdet_acc_id
> arizona->pdata.hpdet_acc_id_line
> arizona->pdata.micd_detect_debounce
> arizona->pdata.jd_gpio5
> arizona->pdata.micd_timeout
> arizona->pdata.num_micd_configs
> arizona->pdata.micd_configs
> arizona->pdata.micd_bias_start_time
> arizona->pdata.micd_rate
> arizona->pdata.micd_dbtime
> arizona->pdata.num_micd_ranges
> ...
> 
> If you fix NULL pointer error about pdata,
> I think only that extcon-arizona modify it as following:
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index e557130..3429906 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1088,6 +1088,10 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>                 return -EPROBE_DEFER;
>  
>         pdata = dev_get_platdata(arizona->dev);
> +       if (!pdata) {
> +               dev_err(&pdev->dev, "Failed to get platform data\n");
> +               return -EINVAL;
> +       }
>  
>         info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>         if (!info) {
> 

Additionally,I have a question.
As I mentioned, extcon-arizon driver don't get pdata from dt parsing.
I think extcon-arizona haven't operated without pdata.

Did you only build test for extcon-arizona?

I'd like you to implement parse function for extcon-arizona
to solve this issue(NULL pointer error).

Thanks
Chanwoo Choi




