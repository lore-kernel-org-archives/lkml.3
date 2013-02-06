Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3BFC4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:56:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39348 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BFC4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:56:47 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fb06d000000f28-66-5111c66d95a2
Content-transfer-encoding: 8BIT
Message-id: <5111C67B.3060909@samsung.com>
Date: Wed, 06 Feb 2013 11:56:59 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Sean Paul <seanpaul@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        "kgene.kim" <kgene.kim@samsung.com>,
        devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Olof Johansson <olofj@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        RAHUL SHARMA <rahul.sharma@samsung.com>, sw0312.kim@samsung.com
Subject: Re: [PATCH v3 1/3] drm/exynos: Get HDMI version from device tree
References: <1360107777-17490-1-git-send-email-seanpaul@chromium.org>
 <1360107777-17490-2-git-send-email-seanpaul@chromium.org>
 <5111A23F.50300@wwwdotorg.org>
 <CAOw6vb+W3phFDJXp3gCx7y0N7mF4o2DpEfTGuNT1pGdKqiCGTg@mail.gmail.com>
 <5111A6D9.7090700@wwwdotorg.org>
 <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
In-reply-to: <CAOw6vbKhsWp7VnqgvECd-P4e5okX6dwKn3P8+phfpG29rA+h7g@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zTd3cY4KBBhv/aFlc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0vXnJWHBLs6Jn/S32Bsa9Cl2MnBwSAiYSyyY3skHY
	YhIX7q0Hsrk4hASWMUrsfbGYBaZo+alHTBCJ6YwSLR+eM4EkeAUEJX5MvgdUxMHBLCAvceRS
	NkiYWUBdYtK8RcwQ9S8YJRZOaWKDqNeSmPlgBVg9i4CqxNtXHCBhNgFzic6Pl8BKhAQUJK5M
	PMYOUiIqECaxc3M6iCkCVD3vSj7IRGaBaSwSj2fdYgcpFxbwlNi16ybUqstMEg/2/wGbwykQ
	LLHr1BawZyQE5rFLrFl1kBEkwSIgIPFt8iGwGyQEZCU2HWCG+FFS4uCKGywTGMVnIflsFsJn
	s5B8toCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGSMRI72Bc1WBxiFGAg1GJh/eGnmCg
	EGtiWXFl7iFGCQ5mJRFehW1AId6UxMqq1KL8+KLSnNTiQ4zJQPdNZJYSTc4HRnNeSbyhsYGx
	oaGloZmppakBacJK4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamCcG3RddLbj7tomDu/DYd3W
	tasqz66Yuchd0Hw1Y13AfovTIWtlJ4fcmLHi9vZaw/onikZm0TKuV/8EJ6zZzVOtmLD/lt7t
	opvaSdMmXD5/w+u0SU561t4VP/9b3WlzeZo9aZbVYdWrQVOf7szMWsH9regzW8L2dzP95Ndu
	OdjuvTdp2tFJ/1bzK7EUZyQaajEXFScCAOYOpFrcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd3cY4KBBr+OKFlc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmtL15yVhwS7Oi
	Z/0t9gbGvQpdjJwcEgImEstPPWKCsMUkLtxbz9bFyMUhJDCdUaLlw3OwBK+AoMSPyfdYuhg5
	OJgF5CWOXMoGCTMLqEtMmreIGaL+BaPEwilNbBD1WhIzH6wAq2cRUJV4+4oDJMwmYC7R+fES
	WImQgILElYnH2EFKRAXCJHZuTgcxRYCq513JB5nILDCNReLxrFvsIOXCAp4Su3bdhFp1mUni
	wf4/YHM4BYIldp3awjaBUXAWkktnIVw6C8mlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefn
	bmIEx+Mz6R2MqxosDjEKcDAq8fDe0BMMFGJNLCuuzD3EKMHBrCTCq7ANKMSbklhZlVqUH19U
	mpNafIgxGejPicxSosn5wFSRVxJvaGxiZmRpZGZsYm5sTJqwkjgv46knAUIC6YklqdmpqQWp
	RTBbmDg4pRoYnWaY3D9lLrdo7rcy07znn4r+/UzxD+R0vpFg/G+y2gdn+6/8fQET+wL+sE2f
	ozUh3P+n1PfWg/HmcVET/DdFlIRt/Z/h/3zm/ierZnaFGt4rP5LqxR/74s+0GMO7cwxWBd5S
	sNz/UdpuXsRa6SNF3y2N35xZ4RWgbqOsP/uKbUnMgi+7wx92K7EUZyQaajEXFScCAPvdKsEL	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2013년 02월 06일 09:56, Sean Paul wrote:
> On Tue, Feb 5, 2013 at 4:42 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/05/2013 05:37 PM, Sean Paul wrote:
>>> On Tue, Feb 5, 2013 at 4:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>> n 02/05/2013 04:42 PM, Sean Paul wrote:
>>>>> Use the compatible string in the device tree to determine which
>>>>> registers/functions to use in the HDMI driver. Also changes the
>>>>> references from v13 to 4210 and v14 to 4212 to reflect the IP
>>>>> block version instead of the HDMI version.
>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/drm/exynos/hdmi.txt b/Documentation/devicetree/bindings/drm/exynos/hdmi.txt
>>>>
>>>> Binding looks sane to me.
>>>>
>>>>> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
>>>>
>>>>>  #ifdef CONFIG_OF
>>>>>  static struct of_device_id hdmi_match_types[] = {
>>>>>       {
>>>>> -             .compatible = "samsung,exynos5-hdmi",
>>>>> -             .data   = (void *)HDMI_TYPE14,
>>>>> +             .compatible = "samsung,exynos4-hdmi",
>>>>>       }, {
>>>>>               /* end node */
>>>>>       }
>>>>
>>>> Why not fill in all the "base" compatible values there (I think you need
>>>> this anyway so that DTs don't all have to be compatible with
>>>> samsung,exynos4-hdmi), with .data containing the HDMI_VER_EXYNOS*
>>>> values, then ...
>>>>
>>>
>>> At the moment, all DTs have to be compatible with exynos4-hdmi since
>>> it provides the base for the current driver. The driver uses 4210 and
>>> 4212 to differentiate between different register addresses and
>>> features, but most things are just exynos4-hdmi compatible.
>>
>> The DT nodes should include only the compatible values that the HW is
>> actually compatible with. If the HW isn't compatible with exynos4-hdmi,
>> that value shouldn't be in the compatible property, but instead whatever
>> the "base" value that the HW really is compatible with. The driver can
>> support multiple "base" compatible values from this table.
>>
> 
> All devices that use this driver are compatible, at some level, with
> exynos4-hdmi, so I think its usage is correct here.
> 
>>>>> @@ -2218,17 +2217,18 @@ static int hdmi_probe(struct platform_device *pdev)
>>>>
>>>>> +
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4210-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4210;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos4212-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS4212;
>>>>> +     if (of_device_is_compatible(dev->of_node, "samsung,exynos5250-hdmi"))
>>>>> +             hdata->version |= HDMI_VER_EXYNOS5250;
>>>>
>>>> Instead of that, do roughly:
>>>>
>>>>     match = of_match_device(hdmi_match_types, &pdev->dev);
>>>>     if (match)
>>>>         hdata->version |= (int)match->data;
>>>>
>>>> That way, it's all table-based. Any future additions to
>>>> hdmi_match_types[] won't require another if statement to be added to
>>>> probe().
>>>
>>> I don't think it's that easy. of_match_device returns the first match
>>> from the device table, so I'd still need to iterate through the
>>> matches. I could still break this out into a table, but I don't think
>>> of_match_device is the right way to probe it.
>>
>> You shouldn't have to iterate over multiple matches. of_match_device()
>> is supposed to return the match for the first entry in the compatible
>> property, then if there was no match, move on to looking at the next
>> entry in the compatible property, etc. In practice, I think it's still
>> not implemented quite correctly for this, but you can make it work by
>> putting the newest compatible value first in the match table.
> 
> I think the only way that works is if you hardcode the compatible
> versions in the driver, like this:
> 
> static struct of_device_id hdmi_match_types[] = {
>         {
>                 .compatible = "samsung,exynos5250-hdmi",
>                 .data = (void *)(HDMI_VER_EXYNOS5250 | HDMI_VER_EXYNOS4212);
>         }, {
>                 .compatible = "samsung,exynos4212-hdmi",
>                 .data = (void *)HDMI_VER_EXYNOS4212;
>         }, {
>                 .compatible = "samsung,exynos4210-hdmi",
>                 .data = (void *)HDMI_VER_EXYNOS4210;
>         }, {
>                 /* end node */
>         }
> };

Actually, I can't understand why there is HDMI_VER_EXYNOS5250 because it
is not used anywhere in your patch. I'm not sure I missed something from
your v2 patch thread, but to me, just hdmi version or hdmi ip version
can be used as data field of struct of_device_id as like your v2 patch
set. and then of_match_device() can be used without | in data field.

If I have missed some point from v2 thread, please let me know.

Best Regards,
- Seung-Woo Kim

> 
> In that case, it eliminates the benefit of using device tree to
> determine the compatible bits. I hope I'm just being thick and missing
> something.
> 
> Sean
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

