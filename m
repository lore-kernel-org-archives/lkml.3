Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbbA2Bsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:48:39 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30286 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbbA2BsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:48:12 -0500
X-AuditID: cbfee691-f79b86d000004a5a-d6-54c972dc1c28
Message-id: <54C972DB.1020808@samsung.com>
Date: Thu, 29 Jan 2015 08:38:03 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: cw00.choi@samsung.com, Chanwoo Choi <cwchoi00@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        "pankaj.dubey@samsung.com" <pankaj.dubey@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
 <54C129B0.1090404@samsung.com> <54C1FBF6.4040405@samsung.com>
 <54C2877A.3040500@samsung.com>
 <CAGTfZH3NM-Y7Q9ru_iyKXFRO67TAc=SG8urwDyUF_qWWKEGVVg@mail.gmail.com>
In-reply-to: <CAGTfZH3NM-Y7Q9ru_iyKXFRO67TAc=SG8urwDyUF_qWWKEGVVg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkQPdO0ckQg4OPZSwu79e2uP7lOavF
	s6PaFpPuT2Cx6H/8mtni8q45bBYzzu9jsng64SKbxaKtX9gtDr9pZ7WYMfklm8WqXX8YHXg8
	ds66y+6xaVUnm8eda3vYPPq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj2/NvzAXdFhWzmi4x
	NzBe0+xi5OSQEDCR2Hy3lRnCFpO4cG89G4gtJLCUUeLFCTWYmkOzXrN3MXIBxaczSsyZ0MwI
	UfSaUaL7Qh6IzSugJfHq8SN2EJtFQFXi17UXYEPZgOL7X9wAGyoqECaxcvoVFoh6QYkfk++B
	2SIC+hJLVl0Eq2EWeMwscfwUfxcjB4ewQKLE7nVcEHuXM0k8P/CeCSTOKRAs8Xq+DES5usSk
	eYuYIWx5ic1r3jKD1EsIfGSXuDb5LBPEPQIS3yYfYgHplRCQldh0AOpfSYmDK26wTGAUm4Xk
	ollIxs5CMnYBI/MqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjMAIPf3v2cQdjPcPWB9iFOBg
	VOLhfWF2IkSINbGsuDL3EKMp0BUTmaVEk/OBaSCvJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbGsyKx3w91v5+i9ut++NSCbYfFww4KXOBi45+V+Oyi
	1K2Us1Kyfi2p2/YpRqxkODdHhjMo/Z/OCoH7CvdXBNrorXkesPPZirU86pEHfz1S93FLc3vz
	g31PS8CS58/c910QPN8Vxd/OyOz3dqvqyWDhV1uyFJgdL7pGhh61OGG0vWYVn+GhmA/1SizF
	GYmGWsxFxYkASge+AcsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoO6dopMhBk+PC1lc3q9tcf3Lc1aL
	Z0e1LSbdn8Bi0f/4NbPF5V1z2CxmnN/HZPF0wkU2i0Vbv7BbHH7TzmoxY/JLNotVu/4wOvB4
	7Jx1l91j06pONo871/awefRtWcXo8XmTXABrVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjG3PvzEXdFtUzGq6xNzAeE2zi5GTQ0LAROLQrNfsELaYxIV769m6GLk4hASm
	M0rMmdDMCJIQEnjNKNF9IQ/E5hXQknj1+BFYA4uAqsSvay+YQWw2oPj+FzfYQGxRgTCJldOv
	sEDUC0r8mHwPzBYR0JdYsuoiWA2zwGNmieOn+LsYOTiEBRIldq/jgti7nEni+YH3TCBxToFg
	idfzZSDK1SUmzVvEDGHLS2xe85Z5AqPALCQbZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4ATwTGoH48oGi0OMAhyMSjy8L8xOhAixJpYVV+YeYpTgYFYS4T3neDJEiDcl
	sbIqtSg/vqg0J7X4EKMpMAAmMkuJJucDk1NeSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJ
	anZqakFqEUwfEwenVAOj7N7o4jvdbPsvSIiqXvh4ckPUjgdbpt+ffiC5zed8o+iujeF6Mexb
	jZ50i+151+UYlniJ91Dhi6UN765OWT4pbP6MXZ/1Fgt62rTqvZU4ueLPI4OS2VNnPpQ9rKr+
	tHe9QuRiuZXWW6aGBpt2L5kbHRBdsPpjAefyC7t1WSSPm3m2xX/LNFU9rsRSnJFoqMVcVJwI
	AJXKd4wWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Do you have any comment about Tomasz and me reply?

Thanks,
Chanwoo Choi

On 01/24/2015 07:05 AM, Chanwoo Choi wrote:
> Hi Sylwester,
> 
> On Sat, Jan 24, 2015 at 2:40 AM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 23/01/15 08:44, Chanwoo Choi wrote:
>>>>> +   cmu_top: clock-controller@0x10030000 {
>>>>>>> +                compatible = "samsung,exynos5433-cmu-top";
>>>>>>> +                reg = <0x10030000 0x0c04>;
>>>>>>> +                #clock-cells = <1>;
>>>>>>> +        };
>>>>>>> +
>>
>>>>>>> +        cmu_fsys: clock-controller@0x156e0000 {
>>>>>>> +                compatible = "samsung,exynos5433-cmu-fsys";
>>>>>>> +                reg = <0x156e0000 0x0b04>;
>>>>>>> +                #clock-cells = <1>;
>>>>>>> +        };
>>>>>
>>>>> What are the reasons to split the whole clock controller into separate
>>>>> device nodes with different compatible strings like this? I doubt drivers
>>>>> associated with each of those compatible strings could be ever reused on
>>>>> different Exynos SoCs.
>>>
>>> No special reason. I added the clock controller according to clock domain
>>> separately. As I knew, samsung clk drivers use this way to support various
>>> clock domains. For exmaple, drivers/clk/samsung/clk-exynos7.c.
>>
>> I'm afraid exynos7 has that initialization ordering issue, unfortunately I
>> didn't notice it before.
> 
> OK.
> 
>>
>>>>> There are hardware dependencies between these clock domains, which are
>>>>> not currently modelled in DT with your binding.
>>>
>>> Right. current samsung clock drivers cannot show the hierarchy among clock
>>> domains in DT.
>>>
>>>>> IOW, there is currently
>>>>> no way to ensure proper registration order of the CMUs (clock domains).
>>>>> This may be important in some cases.
>>>>>
>>>>> To address this we could either add clocks/clock-names properties in
>>>>> respective CMU device nodes, pointing to any clocks in other CMU(s) or
>>>>> make a single device node for the whole clock controller, with an
>>>>> aggregated reg entry, e.g.
>>>>>
>>>>>  cmu: clock-controller@0x10030000 {
>>>>>    compatible = "samsung,exynos5433-cmu";
>>>>>    reg =   <0x10030000 0x0c04>,
>>>>>            <0x10fc0000 0x0c04>,
>>>>>            <0x105b0000 0x100c>,
>>>>>            <0x14c80000 0x0b08>,
>>>>>            <0x10040000 0x0b20>,
>>>>>            <0x156e0000 0x0b04>,
>>>>>                    ...
>>>>>    reg-names = "top", "cpif", "mif", "peric", "peris", "fsys"...
>>>>>    #clock-cells = <1>;
>>>>>  };
>>>
>>> If you make a single device node to support various clock domain,
>>> How are you indicate the specific clock in some clock domain?
>>
>> This might be an issue, we would need to make all the clk indexes a one
>> contiguous set.
> 
> Exynos5433 has a whole lot of clocks against Exynos4 series clocks.
> So, if make all the clocks in the same set, I wonder making too huge set.
> It may cause the complicated code to find the proper clock or to analyze
> the clock driver.
> 
> I'm wondering if there is really any use of having such
>> information expressed explicitly in DT, or it would just make the DT
>> binding closer resembling the SoC's documentation ?
> 
> If we show the hierarchy or dependency between clock domains,
> I think we should modify "structure samsung_clk_provider"
> to include dependency information between clock domains.
> (It is just my opinion, this opinion could be not proper solution.)
> 
> Because
> when we use the common clk framework without adding
> any dependency information between clock domains, it is well working.
> 
>>
>> Similarly, the clock controller is divided into subdomains in older SoCs,
>> like exynos4, yet we do not create separate device nodes for each domain.
>> Is reference to each individual clock domain required in any other SoC's
>> part in case of exynos5433 ?
> 
> There is a difference between exynos4 cmu and exynos5433 cmu.
> exynos4. As I knew, Exynos4 series have the one more clock domain.
> But, there are not any IPs between clock domains. We can check it as following
> read base address and scope.
> 
> The base address and range of Exynos4412 clock domain :
> - 0x1003_0000 ~ 0x1003_CA08
> - 0x1004_0000 ~ 0x1004_8B0C
> 
> But, the clock domain in base address map of exynos5433 is located
> in non-continuous range. Also, there are un-related IPs to clocks.
> (e.g., mct 101c_0000, gic 1100_1000, serial0 14c1_0000, pinctrl 1058_0000 ...)
> If we make the one dt node for clock domains like exynos4,
> I think it may cause the possible issue that clock drivers may access
> the un-related memory-mapped region.
> 
> The base address and range of Exynos5433 clock domain :
> - top domain    : 0x1003_0000 ~ 0x1003_0c04
> - cpif domain   : 0x10fc_0000 ~ 0x10fc_0x0c04
> - mif domain    : 0x105b_0000 ~ 0x105b_0x100c
> - peric domain : 0x14c8_0000 ~ 0x14c8_0b08
> - peris domain  : 0x1004_0000 ~ 0x1004_0x0b20
> - fsys domain   : 0x156e_0000 ~ 0x156e_0b04
> 
>>
>>> For example,
>>> The serial dt node in exynos7.dtsi. serial_0 dt node use the uart clocks
>>> in 'clock_peric0' clock domain and serial_1 dt node use the uart clocks
>>> in 'clock-peric1' clock domain.
>>>
>>> When using the clock in specific clock domain,
>>> we need to phandle(e.g., clock_peric0, clock_peric1) of clock domain.
>>>
>>>               serial_0: serial@13630000 {
>>>                       compatible = "samsung,exynos4210-uart";
>>>                       reg = <0x13630000 0x100>;
>>>                       interrupts = <0 440 0>;
>>>                       clocks = <&clock_peric0 PCLK_UART0>,
>>>                                <&clock_peric0 SCLK_UART0>;
>>>                       clock-names = "uart", "clk_uart_baud0";
>>>                       status = "disabled";
>>>               };
>>>
>>>               serial_1: serial@14c20000 {
>>>                       compatible = "samsung,exynos4210-uart";
>>>                       reg = <0x14c20000 0x100>;
>>>                       interrupts = <0 456 0>;
>>>                       clocks = <&clock_peric1 PCLK_UART1>,
>>>                                <&clock_peric1 SCLK_UART1>;
>>>                       clock-names = "uart", "clk_uart_baud0";
>>>                       status = "disabled";
>>>               };
>>>
>>>>> Then we could modify samsung_cmu_register_one() function by adding
>>>>> the reg entry index or name argument. What do you think ?
>>>
>>> If there is more reasonable way to show the dependency between clock domains,
>>> I will agree.
>>
>> The other option I mentioned is specifying all parent clocks of a given
>> clock domain in its device node with clocks(/clock-names) properties.
>> But it might be a bit hard to list all the clock domain dependencies
>> this way
> 
> Right, I agree that it is too hard.
> 
> Regards,
> Chanwoo Choi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

