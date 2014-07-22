Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaGVCSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:18:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13417 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaGVCST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:18:19 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-07-53cdc9d8559c
Message-id: <53CDC9D7.5000803@samsung.com>
Date: Tue, 22 Jul 2014 11:17:59 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv7 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and
 code clean
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
 <53CCCB20.50802@samsung.com> <53CCCCA8.1030509@samsung.com>
 <4966271.WeZIcVN3eT@wuerfel>
In-reply-to: <4966271.WeZIcVN3eT@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42JZI2JSpHvj5Nlgg9NHxSz+TjrGbnH3+WFG
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i0+NrrBYL25awWMw78o7F4vKuOWwW
	M87vY7JYev0ik8WE6WtZLN7emc5i0br3CLvF+hmvWRyEPNbMW8Po8fvXJEaPy329TB4rl39h
	89i8Qstj06pOIGNJvUffllWMHp83yQVwRnHZpKTmZJalFunbJXBlbPlwmKlgqnDF5r8vWBsY
	t/F3MXJwSAiYSKxZb9XFyAlkiklcuLeerYuRi0NIYCmjxL/bj5ggEiYS2x49Y4FILGKU+H1+
	HyuE85pRYvKCV4wgVbwCWhKX37cwg9gsAqoSF38cZgOx2YDi+1/cALNFBcIkVk6/wgJRLyjx
	Y/I9MFtEQFFi6otnzCBDmQUOMEv8evMQbJCwQITE+je7WOFWH2tcxghyN6eApkTrfHeQGmYB
	HYn9rdPYIGx5ic1r3oINkhDYwSHR9nILC8RFAhLfJh9igfhZVmLTAWaI1yQlDq64wTKBUWwW
	kptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzECU8Hpf8/6djDePGB9iDEZ
	aOVEZinR5HxgKskriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYzieZpKOhIf7KfbhZ+5zDLX+a7CrX+BS2wvVu2YuyJDtsz6+MRH9/q86uzidyp2
	vZwl6fhQvGghl4ffl9sJf4rXTgoXm8Uyo2H1nRtszb4tc5+KnXK8uvnXHoXm69UJ0Wd18859
	+vyqecW06iUuNz08QiT6lbyr95mt/mv9Lo7/giXv7PKt13cosRRnJBpqMRcVJwIAlYJA5hsD	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd0bJ88GG/zay2fxd9Ixdou7zw8z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxdmmN+wWmx5fY7VY2LaExWLekXcsFpd3zWGz
	mHF+H5PF0usXmSwmTF/LYvH2znQWi9a9R9gt1s94zeIg5LFm3hpGj9+/JjF6XO7rZfJYufwL
	m8fmFVoem1Z1AhlL6j36tqxi9Pi8SS6AM6qB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzA
	UNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6CElhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9
	RgZoIGENY8aWD4eZCqYKV2z++4K1gXEbfxcjJ4eEgInEtkfPWCBsMYkL99azdTFycQgJLGKU
	+H1+HyuE85pRYvKCV4wgVbwCWhKX37cwg9gsAqoSF38cZgOx2YDi+1/cALNFBcIkVk6/wgJR
	LyjxY/I9MFtEQFFi6otnzCBDmQUOMEv8evMQbJCwQITE+je7WOFWH2tcBrSNg4NTQFOidb47
	SA2zgI7E/tZpbBC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECE41z6R3MK5qsDjEKMDBqMTDO0HxbLAQa2JZcWXuIUYJDmYlEd72PUAh3pTEyqrU
	ovz4otKc1OJDjKbAIJjILCWanA9Mg3kl8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NT
	C1KLYPqYODilGhiX7Tzw6vwecR6FCAHPsn3tc4oXTpnheSqqdXJUte8d5YPzFgSwOpSe3beF
	6cuDxIZ0OYYpwj726xWLLF54/dwoVPFNfVfz2vdGOXXW+7onL6n2vLEu15jrtBuP0AxnEbk/
	Yn5/Hgn5HmudxTL1+qWI6bZrHHovGYvrcx3jLVS6q9L30cqS/44SS3FGoqEWc1FxIgA0VLEk
	SwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 07/21/2014 05:58 PM, Arnd Bergmann wrote:
> On Monday 21 July 2014 17:17:44 Chanwoo Choi wrote:
>> On 07/21/2014 05:11 PM, Chanwoo Choi wrote:
>>> On 07/21/2014 04:38 PM, Arnd Bergmann wrote:
>>>> On Monday 21 July 2014 11:17:44 Chanwoo Choi wrote:
>>>>>
>>>>> This patchset support Exynos3250 ADC (Analog Digital Converter) because
>>>>> Exynos3250 has additional special clock for ADC IP.
>>>>>
>>>>> Changes from v6:
>>>>> - Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
>>>>> - Use "sclk" clock name instead of "sclk_adc"
>>>>> - Remove un-necessary macro for exyno-adc-data-v2 structure.
>>>>> - Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
>>>>> - Change the number of ADC channels (Exynos3250 has only two channels for ADC)
>>>>>
>>>>
>>>> Looks good to me. Two small requests:
 >>>>
>>>> a) if you don't mind, can you add my patch (1/2) to add support for s3c64xx to
>>>>    your series, adding your Signed-off-by line in addition to mine? I think
>>>>    that one was noncontroversial, while the second patch (2/2) need some more
>>>>    work to address the comments and do testing.
>>>
>>> OK, I'll add this patch.
>>> But, I have a question.
>>>
>>> Your patch add following compatible string.
>>> "s3c64100-adc" is right?
>>>
>>>  static const struct of_device_id exynos_adc_match[] = {
>>>  	{
>>> +		.compatible = "samsung,s3c64100-adc",
>>> +		.data = &exynos_adc_s3c64xx_data,
>>> +	}, {
>>
>> Additionally,
>> Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt has not included
>> "samsung,s3c6410-adc" compatible string. Should I add this string in exynos-adc.txt?
>>
>> drivers/iio/adc/exynos-adc.c has not includeded following compatible string.
>> Should I add this compatible string on exynos-adc.c?
>>
>> +			Must be "samsung,s3c2410-adc" for
>> +				the ADC in s3c2410 and compatibles
>> +			Must be "samsung,s3c2416-adc" for
>> +				the ADC in s3c2416 and compatibles
>> +			Must be "samsung,s3c2440-adc" for
>> +				the ADC in s3c2440 and compatibles
>> +			Must be "samsung,s3c2440-adc" for
>> +				the ADC in s3c2440 and compatibles
>> +			Must be "samsung,s3c2443-adc" for
>> +				the ADC in s3c2443 and compatibles
>>
> 
> 
> Yes, please.

I send following patchset[1] to support s3c24xx/s3c64xx ADC.
[1] http://www.spinics.net/lists/kernel/msg1791305.html

Thanks,
Chanwoo Choi


