Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbbAUJjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:39:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18606 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbbAUJjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:39:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-91-54bf73ba5806
Message-id: <54BF73B9.8060402@samsung.com>
Date: Wed, 21 Jan 2015 10:39:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Rob Herring <robherring2@gmail.com>, linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        sakari.ailus@iki.fi, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
References: <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com>
 <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
 <54B8D4D0.3000904@samsung.com>
 <CAL_Jsq+EFWzs1HP1tVt6P=p=HZn2AtSPjp55YrmMQi_mE+kNfQ@mail.gmail.com>
 <54B933D0.1090004@samsung.com> <54BE7DAB.80702@samsung.com>
 <CAL_JsqKoiaUmVhbQdnNveG=AAYh4-OHGS70L+LAgLLoKChUuYQ@mail.gmail.com>
 <20150120174010.GA2900@amd>
In-reply-to: <20150120174010.GA2900@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xK7q7iveHGHy4b2CxccZ6VoupD5+w
	WRzdOZHJYv6Rc6wW/W8Wslqce7WS0eJs0xt2i29XOpgsLu+aw2ax9c06RoueDVtZLZZev8hk
	cffUUTaLCdPXsli07j3CbvH92zc2i927nrJaHH7TzmpxZv9KNgdhjzXz1jB6XO7rZfLYOesu
	u8fK5V/YPA5/XcjisWlVJ5vHnvk/WD36tqxi9Fix+ju7x+dNcgFcUVw2Kak5mWWpRfp2CVwZ
	r/fNZiu4zF1x5c451gbGRZxdjJwcEgImEvsPPGCFsMUkLtxbz9bFyMUhJLCUUWLlynXMEM5H
	Ron9J8+BVfEKaEn82dbCAmKzCKhKzD3eBmazCRhK/HzxmgnEFhWIkPhzeh9UvaDEj8n3wGpE
	BOQltvatABvKLPCdVWLD/9PsIAlhAVeJ2e2LobatZZH4MGE/G0iCU0BDYnPzIkYQm1nAWmLl
	pG1QtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJ
	yi87GBcfszrEKMDBqMTDWxG6P0SINbGsuDL3EKMEB7OSCO+TAqAQb0piZVVqUX58UWlOavEh
	RiYOTqkGxmyd+HqzM6tncanZf73M9lSsM/J57q85u17wW1/Yas6tfEn+eJ283KQSdrXLi6ZZ
	fbr+/8GZC76T9mglvX/Fw3Hol5Jl69+5vrmRjiFtMXstmr4xPeE19akq6s6QY7u4uVXkZYpb
	4Rb2QAZ9zbc5O+PnrnJZ+Ucy38nmTrHdTk7PSK6EigNGSizFGYmGWsxFxYkA9GnD66gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 06:40 PM, Pavel Machek wrote:
> On Tue 2015-01-20 11:29:16, Rob Herring wrote:
>> On Tue, Jan 20, 2015 at 10:09 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>> On 01/16/2015 04:52 PM, Jacek Anaszewski wrote:
>>>>
>>>> On 01/16/2015 02:48 PM, Rob Herring wrote:
>>
>> [...]
>>
>>>>> You may want to add something like led-output-cnt or led-driver-cnt in
>>>>> the parent so you know the max list size.
>>>>
>>>>
>>>> Why should we need this? The number of current outputs exposed by the
>>>> device is fixed and can be specified in a LED device bindings
>>>> documentation.
>>>>
>>>
>>> OK. The led-output-cnt property should be put in each sub-node, as the
>>> number of the current outputs each LED can be connected to is variable.
>>
>> Sorry, I meant this for the parent node meaning how many outputs the
>> driver IC has. I did say maybe because you may always know this. It
>> can make it easier to allocate memory for led-sources knowing the max
>> size up front.
>
> Umm. Not sure if that kind of "help" should go to the device
> tree.
> 									Pavel
>

I agree. I think that led-sources-cnt is redundant. A list property
can be read using of_prop_next_u32 function. I missed that and thus
proposed putting led-sources-cnt in each sub-node to be able to read 
led-sources list with of_property_read_u32_array.

Effectively, I propose to avoid adding led-sources-cnt property.

-- 
Best Regards,
Jacek Anaszewski
