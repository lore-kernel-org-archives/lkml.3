Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3HTXH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:07:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38749 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3HTXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:07:25 -0400
X-AuditID: cbfee68f-b7f436d000000f81-db-5213f6aa41a0
Message-id: <5213F6AB.80307@samsung.com>
Date: Wed, 21 Aug 2013 08:07:23 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: George Cherian <george.cherian@ti.com>
Cc: balbi@ti.com, myungjoo.ham@samsung.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, bcousson@baylibre.com
Subject: Re: [PATCH 1/2] extcon: extcon-dra7xx: Add extcon driver for USB ID
 detection
References: <1376648029-30659-1-git-send-email-george.cherian@ti.com>
 <1376648029-30659-2-git-send-email-george.cherian@ti.com>
 <5212B740.2000000@samsung.com> <521338B7.7040208@ti.com>
 <52134513.1060304@samsung.com> <52136E1A.8020900@ti.com>
In-reply-to: <52136E1A.8020900@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42JZI2JSorvqm3CQwc9PGhYH79db3Jn/l9Vi
	/pFzrBanDi5ntTjwZwejxZveDhaLhW1LWCwu75rDZjF7ST+LxaJlrcwWS69fZLK43biCzWLC
	9LUsFodXHGCyWPdyOovFq4NtLA4CHmvmrWH0eH+jld1jwecr7B6vJ09g9Hi1eiarx51re9g8
	+rasYvQ4fmM7k8fnTXIeG+eGBnBFcdmkpOZklqUW6dslcGUsbVjFXPCXt+LWramMDYxnuboY
	OTgkBEwk5i/w6mLkBDLFJC7cW8/WxcjFISSwlFHi0urXzBAJE4mGs68YIRKLGCW2Nc9lgnBe
	MUrsmH+XBaSKV0BDomvWOUYQm0VAVeLw0V/sIDabgJbE/hc32EBsUYEwiZXTr0DVC0r8mHwP
	zBYBqum/1A02lFngC5PErFWz2UHOExaIkLiwQgFi2XdGieczbjCBNHAKqEm0TPkL1swsoCOx
	v3UaG4QtL7F5zVtmkAYJgR0cEievrmeBuEhA4tvkQywQP8tKbDoA9ZqkxMEVN1gmMIrNQnLT
	LCRjZyEZu4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYAI4/e9Z/w7GuwesDzEmA62c
	yCwlmpwPTCB5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamAMfX/5yOKXqSKX9xyMsLk/rbLElv/a1VtTv4el7446IHLbNrlG/YkY9/2zxdvPWtco
	TdkWUHfvruElcdv/XdsK9niICHG9/30hyvj/TMUv5s48ez8xcUt1HHBedqY5KfptR07ZhRNT
	tB6+0HvIzXnrQN8W8dj1v8IZuvhvTnWX+mP1+PSB6qN7lFiKMxINtZiLihMBtvUlGhYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsVy+t9jAd1V34SDDLafk7c4eL/e4s78v6wW
	84+cY7U4dXA5q8WBPzsYLd70drBYLGxbwmJxedccNovZS/pZLBYta2W2WHr9IpPF7cYVbBYT
	pq9lsTi84gCTxbqX01ksXh1sY3EQ8Fgzbw2jx/sbreweCz5fYfd4PXkCo8er1TNZPe5c28Pm
	0bdlFaPH8RvbmTw+b5Lz2Dg3NIArqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmgg
	YQ1jxtKGVcwFf3krbt2aytjAeJari5GTQ0LARKLh7CtGCFtM4sK99WxdjFwcQgKLGCW2Nc9l
	gnBeMUrsmH+XBaSKV0BDomvWObAOFgFVicNHf7GD2GwCWhL7X9xgA7FFBcIkVk6/AlUvKPFj
	8j0wWwSopv9SN9hQZoEvTBKzVs0GaubgEBaIkLiwQgFi2XdGieczbjCBNHAKqEm0TPkL1sws
	oCOxv3UaG4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxghPMM+kdjKsaLA4xCnAwKvHwbigUDhJiTSwrrsw9xCjBwawkwrvjK1CINyWxsiq1KD++
	qDQntfgQYzIwCCYyS4km5wOTX15JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNITS1KzU1ML
	UotgtjBxcEo1MG50mhZnf3WSfK/c3zVHHnHHR/+/Lt82a8MGi7idVVG/90VFTHL0uGlcWil+
	522d4guRR18+ebukpIm8UVnhuGfmVTODooKmGb99drc3CM0VlRK9c1pstcYEjqi3z95ZFczY
	Ocv2oYjEzH83+ITMHW5sMdS8saU+r5PnQR3nnqsaLp7vOoNitiqxFGckGmoxFxUnAgBwFulX
	dAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> +
>>>>> +    if (dra7xx_usb->irq_gpio) {
>>>>> +        status = devm_request_threaded_irq(dra7xx_usb->dev, irq_num,
>>>>> +                NULL, id_irq_handler, IRQF_SHARED |
>>>>> +                IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
>>>>> +                dev_name(&pdev->dev), (void *) dra7xx_usb);
>>>>> +        if (status)
>>>>> +            dev_err(dra7xx_usb->dev, "failed to request irq #%d\n",
>>>>> +                        irq_num);
>>>> If devm_request_threaded_irq() return fail state, why did not you do add error exception?
>>> If interrupt fails I fallback to polling thread.
>>>>> +        else
>>>>> +            return 0;
>>>> If devm_request_threaded_irq() return success state, why did you directly call 'return'?
>>>> kthread_create operation isn't necessary?
>>> Yes kthread is optional. Some boards doenot have the ID pin hooked onto the GPIO.
>>> In such cases we will run the kthread and poll on the ID pin values.
>>>>> +    }
>>>>> +
>>>>> +    dra7xx_usb->thread_task = kthread_create(id_poll_func, dra7xx_usb,
>>>>> +                         dev_name(&pdev->dev));
>>>> Should you use polling method with kthread? I think it isn't proper method.
>>>> You did get the irq number by using DT helper function and register irq handler
>>>> with devm_request_threaded_irq(). I prefer interrupt method for detection of cable state.
>>> I also prefer interrupt method. If any implementation does not have ID pin connected to GPIOs then still
>>> it could use the driver in polling mode.
>> As I mentioned above, I don't prefer interrupt method for cable detection.
> 
> I hope you meant, you prefer interrupt method for cable detection over polling .

Right, my mistake. I prefer interrupt method.

Thanks,
Chanwoo CHoi


