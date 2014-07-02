Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaGBE2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 00:28:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15123 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaGBE16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 00:27:58 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-54-53b38a4b93f8
Message-id: <53B38A4B.4020407@samsung.com>
Date: Wed, 02 Jul 2014 13:27:55 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <spk.linux@gmail.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: Add TMU dt node to monitor the temperature for
 Exynos3250
References: <1404175210-9278-1-git-send-email-cw00.choi@samsung.com>
 <CAK5sBcFJMK-y+MZPXCufKEmp=v1nFJHstvNTczsQ3ez3SUPbKw@mail.gmail.com>
 <53B23362.7080103@samsung.com>
 <CAK5sBcER-rFmqe74b8uS=ZxKnTNGtkE0x6f7zaLphmyuHJz7Yg@mail.gmail.com>
 <53B349AF.4080606@samsung.com>
 <CAK5sBcHrMPweMSxfde0SSDOtRHbf7t7WQZkf0wAZNTc+N2=Wgg@mail.gmail.com>
In-reply-to: <CAK5sBcHrMPweMSxfde0SSDOtRHbf7t7WQZkf0wAZNTc+N2=Wgg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsWyRsSkWNe7a3OwwedFshaT1h1gsph/5Byr
	Rf+bhawW516tZLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NaLL1+kcliwvS1LBat
	e4+wW7R8PcdisX7GaxYHfo8189YwerQ097B5XO7rZfL4u+oFs8fOWXfZPVYu/8LmsWlVJ5vH
	5iX1Hn1bVjF6fN4kF8AVxWWTkpqTWZZapG+XwJVx5lcvW8FW0YoPn6azNzAuEuhi5OSQEDCR
	mPnpNjOELSZx4d56NhBbSGApo8SMe0IwNc2vWoBquIDi0xkl5vf+ZIVwXjNKPFjfwARSxSug
	JdG24ys7iM0ioCrR/OUwK4jNBhTf/+IG2FRRgTCJldOvsEDUC0r8mHwPzBYRUJOYefY0G8hQ
	ZoGvLBJr2nczdjFycAgLREnsOsQGsew2k8TJWf/BFnAKBEss6JwLtoBZQF1i0rxFzBC2vMTm
	NW/BTpUQWMkh8fvHJiaIiwQkvk0+xAIyVEJAVmLTAaiXJSUOrrjBMoFRbBaSm2YhGTsLydgF
	jMyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj/vS/Z307GG8esD7EmAy0ciKzlGhyPjBt
	5JXEGxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRpF9
	j2JbH9sHHtr0PeixvBuXrdm5oLxZy/f8WB/xsVfNmCVYWetWf91HfadpqeZn7V9vZjXprjgf
	x2158tBFiRihT7dV+da8kFI6zspUXbLRbe79Mp1ZcSdflM1XC60N3x8ewVLu+O+M5Cut/6JL
	HkyLO1/rxPTywfe/KxO/nVjDoMG0dNVVLyWW4oxEQy3mouJEAFtyqzgRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV3vrs3BBi93iFhMWneAyWL+kXOs
	Fv1vFrJanHu1ktGid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVncvsxrsfT6RSaLCdPXsli0
	7j3CbtHy9RyLxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8nj76oXzB47Z91l91i5/Aubx6ZVnWwe
	m5fUe/RtWcXo8XmTXABXVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QG0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjDO/
	etkKtopWfPg0nb2BcZFAFyMnh4SAiUTzqxZmCFtM4sK99WxdjFwcQgLTGSXm9/5khXBeM0o8
	WN/ABFLFK6Al0bbjKzuIzSKgKtH85TAriM0GFN//4gYbiC0qECaxcvoVFoh6QYkfk++B2SIC
	ahIzz54G28As8JVFYk37bsYuRg4OYYEoiV2HoDbfZpI4Oes/2AJOgWCJBZ1zwRYwC6hLTJq3
	iBnClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFp
	5ZnUDsaVDRaHGAU4GJV4eCPubgoWYk0sK67MPcQowcGsJMIbz7M5WIg3JbGyKrUoP76oNCe1
	+BCjKTAIJjJLiSbnA1NeXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYO
	TqkGRn/dRS6Tt/Z3nRN9wH42s4n93cN96spOqQ8ep98p7AiRcdYIW7+2vlf5ddHCVxnFMdPW
	rC/oML6Qbe82ba7DI8VJdRPy73BNmXRY7nREdaFI9KplthZCpSbXfNiCuCRvP7n+8YJNhel7
	D/WPywp+vlDfEfBU16f2tGHW7jfMHNfWWDou9cn8ocRSnJFoqMVcVJwIAHj208pBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 07/02/2014 12:09 PM, Sachin Kamat wrote:
> On Wed, Jul 2, 2014 at 5:22 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> On 07/01/2014 01:10 PM, Sachin Kamat wrote:
>>> Hi Chanwoo,
>>>
>>> On Tue, Jul 1, 2014 at 9:34 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>> Hi Sachin,
>>>>
>>>> On 07/01/2014 12:33 PM, Sachin Kamat wrote:
>>>>> Hi Chanwoo,
>>>>>
>>>>> On Tue, Jul 1, 2014 at 6:10 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>>>>> This patch add TMU (Thermal Management Unit) dt node to monitor the high
>>>>>> temperature for Exynos3250.
>>>>>>
>>>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>> ---
>>>>>> This patch has a dependency on following patch [1]:
>>>>>>  [1] https://lkml.org/lkml/2014/6/30/805
>>>>>>
>>>>>>  arch/arm/boot/dts/exynos3250.dtsi | 10 ++++++++++
>>>>>>  1 file changed, 10 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
>>>>>> index 3660cab..1e566af 100644
>>>>>> --- a/arch/arm/boot/dts/exynos3250.dtsi
>>>>>> +++ b/arch/arm/boot/dts/exynos3250.dtsi
>>>>>> @@ -192,6 +192,16 @@
>>>>>>                         status = "disabled";
>>>>>>                 };
>>>>>>
>>>>>> +               tmu: tmu@100C0000 {
>>>>>> +                       compatible = "samsung,exynos3250-tmu";
>>>>>> +                       interrupt-parent = <&gic>;
>>>>>> +                       reg = <0x100C0000 0x100>;
>>>>>> +                       interrupts = <0 216 0>;
>>>>>> +                       clocks = <&cmu CLK_TMU_APBIF>;
>>>>>> +                       clock-names = "tmu_apbif";
>>>>>> +                       status = "disabled";
>>>>>
>>>>> I don't think there would be any board specific properties needed. Hence
>>>>> leave the status as enabled (by deleting the above line).
>>>>>
>>>>
>>>> I think that if specific board need TMU feature, dts file for specific board
>>>> should include tmu dt node with 'okay' status. The specific board based on
>>>> Exynos3250 might not need TMU feature.
>>>
>>> The status field in DT node is not meant for stating the build configuration but
>>> represents the readiness of the hardware for usage on the platform. If
>>> a particular
>>> board does not need this feature it needs to be disabled in the build
>>> config and only
>>> for any special requirements disable it in board file.
>>
>> TMU (Thermal Management Unit) needs specific regulator for TMU power as following:
>> The regulator for TMU is dependent on board.
> 
> In this case it makes sense to leave it disabled in dtsi.
> 

Thanks for your review.

Best Regards,
Chanwoo Choi
