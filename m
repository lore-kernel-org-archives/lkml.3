Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaK0MOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:14:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37630 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbaK0MOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:14:46 -0500
X-AuditID: cbfee68d-f79296d000004278-f4-547715b3a249
Message-id: <547715B2.3070508@samsung.com>
Date: Thu, 27 Nov 2014 21:14:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        mark.rutland@arm.com, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, tomasz.figa@gmail.com, thomas.abraham@linaro.org,
        linus.walleij@linaro.org, kyungmin.park@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        geunsik.lim@samsung.com, sw0312.kim@samsung.com,
        jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for
 CMU_BUS{0|1|2} domains
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com>
 <1417073716-22997-12-git-send-email-cw00.choi@samsung.com>
 <6217579.xNXtO7YiDs@wuerfel> <54771173.6090408@samsung.com>
 <54771518.1010004@samsung.com>
In-reply-to: <54771518.1010004@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWyRsSkQHezaHmIwdutQhaP1yxmsvg76Ri7
	xftlPYwWl/drW8w/co7V4s+EVjaLSfcnsFjc+NXGatG74CqbxdmmN+wWU/4sZ7LY9Pgaq8Xl
	XXPYLGac38dksfT6RSaLU9c/s1kcftPOajFj8ks2i2MzljBarNr1h9Hi5ccTLA6iHmvmrWH0
	+P1rEqPHzll32T3uXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAEcVlk5Kak1mWWqRvl8CVcWbz
	CtaCiXwVj34uYWxg3MLdxcjJISFgInHw7FxmCFtM4sK99WxdjFwcQgJLGSXmbm9lhCn68fIR
	VGIRo8SjszOgnNeMEj8a97GBVPEKaEn8W7ANbBSLgKrEthntYN1sQPH9L26A1YgKhEmsnH6F
	BaJeUOLH5HtgtoiAvsSSVRfBapgFprJInP5cDGILC8RIXF3zlxFi2UNGiVe/T4E1cApoS0x5
	chkowQHUoCdx/6IWRK+8xOY1b5lB6iUEjnBI7N/9lBXiIAGJb5MPsYDUSwjISmw6APWypMTB
	FTdYJjCKzUJy0iyEqbOQTF3AyLyKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzA5nP73rHcH
	4+0D1ocYBTgYlXh4LQ6UhQixJpYVV+YeYjQFOmIis5Rocj4wBeWVxBsamxlZmJqYGhuZW5op
	ifMqSv0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBooVNsdey5mZWs4/MzMb7W8eV2OyKb
	GJ9Vmcg9eVq3lptB/S1vJV/rmeezAt0KL0008DBYumr5nDCpyE+zIuOu39pjeyA41GJLcAVj
	fNUVFtGq/YeLItgD+w+erKh9WzHh8Jkn3+pk7620F1n1avb7hFs1sm1LnC5GXbayP7iVZePz
	LXEqet+VWIozEg21mIuKEwG22O75CQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd3NouUhBvNucFo8XrOYyeLvpGPs
	Fu+X9TBaXN6vbTH/yDlWiz8TWtksJt2fwGJx41cbq0XvgqtsFmeb3rBbTPmznMli0+NrrBaX
	d81hs5hxfh+TxdLrF5ksTl3/zGZx+E07q8WMyS/ZLI7NWMJosWrXH0aLlx9PsDiIeqyZt4bR
	4/evSYweO2fdZfe4c20Pm8fmJfUeV040sXr0bVnF6PF5k1wAR1QDo01GamJKapFCal5yfkpm
	XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GtKCmWJOaVAoYDE4mIlfTtME0JD
	3HQtYBojdH1DguB6jAzQQMIaxowzm1ewFkzkq3j0cwljA+MW7i5GTg4JAROJHy8fsUHYYhIX
	7q0Hsrk4hAQWMUo8OjsDynnNKPGjcR9YFa+AlsS/BduYQWwWAVWJbTPaGUFsNqD4/hc3wGpE
	BcIkVk6/wgJRLyjxY/I9MFtEQF9iyaqLYDXMAlNZJE5/LgaxhQViJK6u+csIsewho8Sr36fA
	GjgFtCWmPLkMlOAAatCTuH9RC6JXXmLzmrfMExgFZiFZMQuhahaSqgWMzKsYRVMLkguKk9Jz
	jfSKE3OLS/PS9ZLzczcxglPPM+kdjKsaLA4xCnAwKvHwWhwoCxFiTSwrrsw9xCjBwawkwsvF
	WB4ixJuSWFmVWpQfX1Sak1p8iNEUGAATmaVEk/OBaTGvJN7Q2MTMyNLI3NDCyNhcSZz3xs3c
	ECGB9MSS1OzU1ILUIpg+Jg5OqQbGNj3tbTydD+ofyWx/ZexbLH1/Qmre3b7JygKy/6fevt/X
	deqgysEvEQoH5idU3Jq760LFnaU7DU9NCn01YefB9Qo3Dk/cUuV8J/yq0430mAeKunYXX7m/
	2OGSXtkS3P+/cffKyc7ZevNOnp6/4NzjGzNKPG42T/1pqJqd5Z4QZFdzOumMyKJEQSWW4oxE
	Qy3mouJEABYsGftTAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On 11/27/2014 09:12 PM, Sylwester Nawrocki wrote:
> Hi,
> 
> On 27/11/14 12:56, Chanwoo Choi wrote:
>> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
>>>> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
>>>>>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
>>>>>> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
>>>>>> +    which generates global data buses clock and global peripheral buses clock.
>>>>>>  
>>>>>>  - reg: physical base address of the controller and length of memory mapped
>>>>>>    region.
>>>>>>
>>>>
>>>> This looks like you are duplicating the bindings and the code, but
>>>> it's really the same hardware multiple times with minor variations
>>>> that you should be able to describe properly here. Why not make
>>>> three nodes with the same compatible string and have them handled
>>>> by the same code?
>>
>> Each CMU_BUSx domain of Exynos5433 have different base address as following:
>> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
>> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
>> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
>>
>> So, I implement CMU_BUSx domain which has each compatible string.
> 
> You can always have multiple entries in the reg property. I've done
> something like this for the exynos4415 CMU_ISPx units:
> 
> 	cmu_isp: clock-controller@12060000 {
> 		compatible = "samsung,exynos4415-cmu-isp";
> 		reg = <0x12060000 0xB10>, <0x12070000 0xB10>;
> 		#clock-cells = <1>;
> 
> 		assigned-clocks = <&cmu CLK_FOUT_ISP_PLL>;
> 		assigned-clock-rates = <300000000>;
> 	};

Thanks for your guide.

I'll re-implment CMU_BUSx domain according to your guide.

Best Regards,
Chanwoo Choi

