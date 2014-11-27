Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaK0M67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:58:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41730 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbaK0M64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:58:56 -0500
X-AuditID: cbfee68e-f79b46d000002b74-10-5477200dcbcd
Message-id: <5477200D.5030706@samsung.com>
Date: Thu, 27 Nov 2014 21:58:53 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, tomasz.figa@gmail.com,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <54771173.6090408@samsung.com> <54771518.1010004@samsung.com>
 <3556463.Me1EFEY7Zb@wuerfel>
In-reply-to: <3556463.Me1EFEY7Zb@wuerfel>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWyRsSkWJdPoTzEoOkXq8XjNYuZLP5OOsZu
	8X5ZD6PF5f3aFvOPnGO1+DOhlc1i0v0JLBY3frWxWvQuuMpmcbbpDbvFlD/LmSw2Pb7GanF5
	1xw2ixnn9zFZLL1+kcni1PXPbBaH37SzWsyY/JLN4tiMJYwWq3b9YbR4+fEEi4Oox5p5axg9
	fv+axOixc9Zddo871/aweWxeUu9x5UQTq0ffllWMHp83yQVwRHHZpKTmZJalFunbJXBlfL70
	irngoWTFjF3NLA2MM0S6GDk4JARMJK4+MOhi5AQyxSQu3FvP1sXIxSEksJRRYv3iNlaIhIlE
	/6UvjBCJRYwSpyc+hHJeM0r83rKRCaSKV0BLYu7ZdSwgNouAqsSCFy8YQWw2oPj+FzfYQGxR
	gTCJldOvsEDUC0r8mHwPzBYRUJSY+uIZM8hQZoGlLBLfpv1kB0kIC8RIXF3zF2rbEkaJdYva
	wSZxCmhKNCz7DWYzC+hI7G+dBmXLS2xe85YZ4u4THBI3bulCXCQg8W3yIRaIn2UlNh2AKpGU
	OLjiBssERrFZSG6ahWTqLCRTFzAyr2IUTS1ILihOSi8y0itOzC0uzUvXS87P3cQITA+n/z3r
	28F484D1IUYBDkYlHl6LA2UhQqyJZcWVuYcYTYGumMgsJZqcD0xCeSXxhsZmRhamJqbGRuaW
	ZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MAp3b31ov/PG0/tr37N+SkpdcU+1
	aYHy/4kPNLinTSku3Pbca0bl3rcP/rIf6e+/N+XR3Af3PmS2OZ+6qXeAb3r5s8viLrrTnRXz
	uyoNiyPcMjRlV1yfv+Adh9v7Q3M73vGUts9h8Fp2NDU8YJPbtK8ba05bGefX7Ff3OeDzRCTC
	tExNPYSF87MSS3FGoqEWc1FxIgBuN82ICgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAV1ehfIQg/6HFhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1kcftPOajFj8ks2i2MzljBarNr1h9Hi5ccTLA6iHmvmrWH0
	+P1rEqPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAEdXAaJORmpiSWqSQmpecn5KZ
	l26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkD9JqSQlliTilQKCCxuFhJ3w7ThNAQ
	N10LmMYIXd+QILgeIwM0kLCGMePzpVfMBQ8lK2bsamZpYJwh0sXIySEhYCLRf+kLI4QtJnHh
	3nq2LkYuDiGBRYwSpyc+ZIRwXjNK/N6ykQmkildAS2Lu2XUsIDaLgKrEghcvwLrZgOL7X9xg
	A7FFBcIkVk6/wgJRLyjxY/I9MFtEQFFi6otnzCBDmQWWskh8m/aTHSQhLBAjcXXNX6htSxgl
	1i1qB5vEKaAp0bDsN5jNLKAjsb91GpQtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxghPQM6kdjCsbLA4xCnAwKvHwWhwoCxFiTSwrrsw9xCjBwawk
	wsvFWB4ixJuSWFmVWpQfX1Sak1p8iNEUGAYTmaVEk/OByTGvJN7Q2MTMyNLI3NDCyNhcSZz3
	xs3cECGB9MSS1OzU1ILUIpg+Jg5OqQbGqSyL1x3neSsowpD1bUX+wUzzvsTA9tNCp+NPynhP
	NNG4x76uMrmXe6n8q93rz7zuSYrYsMalsO3Lr9sXbi7Q7rrBvX9ZmencZT2L7P80Fakb5EUY
	rw7Qizghl3A7IXzt7/efBF8uLEm6cvLUsfAHIX8OFLIl213YFZ2wTC61OPmQRuOiKrNiJZbi
	jERDLeai4kQAQ3hYzlYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Arnd,

On 11/27/2014 09:35 PM, Arnd Bergmann wrote:
> On Thursday 27 November 2014 13:12:08 Sylwester Nawrocki wrote:
>> On 27/11/14 12:56, Chanwoo Choi wrote:
>>> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
>>>>> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
>>>>>>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
>>>>>>> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
>>>>>>> +    which generates global data buses clock and global peripheral buses clock.
>>>>>>>  
>>>>>>>  - reg: physical base address of the controller and length of memory mapped
>>>>>>>    region.
>>>>>>>
>>>>>
>>>>> This looks like you are duplicating the bindings and the code, but
>>>>> it's really the same hardware multiple times with minor variations
>>>>> that you should be able to describe properly here. Why not make
>>>>> three nodes with the same compatible string and have them handled
>>>>> by the same code?
>>>
>>> Each CMU_BUSx domain of Exynos5433 have different base address as following:
>>> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
>>> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
>>> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
>>>
>>> So, I implement CMU_BUSx domain which has each compatible string.
> 
> But the base address is in the reg property, not in the compatible
> property. What I mean is to have multiple nodes like

The merged clock driver in mainline have different compatible string
if base addresss of clock domain is different. So, I implemented each CMU_BUSx domain
with different compatible string.

> 
> 	clock-controller@113600000 {
> 		reg = <0 0x113600000 0 0x1000>;
> 		compatible = "samsung,exynos5433-cmu";
> 		#clock-cells = <1>;
> 	};
> 
> 	clock-controller@114800000 {
> 		reg = <0 0x114800000 0 0x1000>;
> 		compatible = "samsung,exynos5433-cmu";
> 		#clock-cells = <1>;
> 	};
> 
> The code will just map the local registers for each instance and then
> provide the clocks of the right instance when asked for it.

Each clock domain has not the same mux/divider/clock. So, just one compatible
string could not support all of clock domains.

Best Regards,
Chanwoo Choi

> 
>> You can always have multiple entries in the reg property. I've done
>> something like this for the exynos4415 CMU_ISPx units:
>>
>>         cmu_isp: clock-controller@12060000 {
>>                 compatible = "samsung,exynos4415-cmu-isp";
>>                 reg = <0x12060000 0xB10>, <0x12070000 0xB10>;
>>                 #clock-cells = <1>;
>>
>>                 assigned-clocks = <&cmu CLK_FOUT_ISP_PLL>;
>>                 assigned-clock-rates = <300000000>;
>>         };
> 
> This is a different problem, this is a clock controller with multiple
> sets of registers that are all different. In case of the cmu, it seems
> that they are all the same, you just have multiple copies at different
> locations, and they are connected to different devices.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

