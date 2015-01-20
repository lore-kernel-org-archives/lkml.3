Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbbATLh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:37:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42910 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbATLhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:37:55 -0500
X-AuditID: cbfee68d-f79296d000004278-ea-54be3e11f871
Message-id: <54BE3E10.2080906@samsung.com>
Date: Tue, 20 Jan 2015 20:37:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
 <1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
 <CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
 <CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
 <54BE108F.8090506@samsung.com>
 <CAKohpokSuVhH3hHFF+mLtJXvjt=bmJy1oZRBOttCNXORBS1Y0A@mail.gmail.com>
In-reply-to: <CAKohpokSuVhH3hHFF+mLtJXvjt=bmJy1oZRBOttCNXORBS1Y0A@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsWyRsSkRFfQbl+Iwc9J/BaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJu8f3bNzaLVbv+MFps/OrhIOixZt4aRo+ds+6yeyze85LJY9OqTjaPO9f2sHls
	XlLv0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBkdf7tZC5YpVfzY84W9gfGvRBcjJ4eEgInE
	6mNv2SBsMYkL99YD2VwcQgJLGSVmL3jMBFP0ef1zVojEdEaJKXMeMEE4rxklPp+fwApSxSug
	JTFt/kWwUSwCqhLvFt0H62YDiu9/cQMsLioQJrFy+hUWiHpBiR+T7wHZHBwiQDUvb6aCzGQW
	mMAm0fDjDVi9sECexKlHN5ghln1lkni/bT8jSIJTIFji5sNtYIuZBdQlJs1bxAxhy0tsXvMW
	rEFCYCWHxJJNkxghLhKQ+Db5ENg2CQFZiU0HmCFek5Q4uOIGywRGsVlIbpqFZOwsJGMXMDKv
	YhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiM+9P/nvXuYLx9wPoQowAHoxIP74tVe0OEWBPL
	iitzDzGaAl0xkVlKNDkfmFzySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphakFsUX
	leakFh9iZOLglGpgZOfWN1mhu3Ha2gUurm1JLjNd459fW7qS+/Im074Zyw8bBU3nauDa1NTu
	Pek8H+/etsbQ2Ys1Xiq7XjISENku4SG/rXreuVtXWJsYl0h+nf7m3MyEPs4Agd9httxXF1xh
	C3fel7l9yVruqTuXXju+is2wLNdx/ue3Mk+FRI0/efx8le64/WzNHiWW4oxEQy3mouJEAMdW
	h1/2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQV1Bu30hBrPOslo8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xfdv39gsVu36w2ix8auHg6DHmnlrGD12zrrL7rF4z0smj02rOtk87lzbw+ax
	eUm9R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXm
	ptoqufgE6Lpl5gB9oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM6Pjb
	zVqwTKnix54v7A2MfyW6GDk5JARMJD6vf84KYYtJXLi3nq2LkYtDSGA6o8SUOQ+YIJzXjBKf
	z08Aq+IV0JKYNv8iG4jNIqAq8W7RfSYQmw0ovv/FDbC4qECYxMrpV1gg6gUlfky+B2RzcIgA
	1by8mQoyk1lgAptEw483YPXCAnkSpx7dYIZY9pVJ4v22/YwgCU6BYImbD7eBLWYWUJeYNG8R
	M4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPK
	M+kdjKsaLA4xCnAwKvHwOqzdGyLEmlhWXJl7iFGCg1lJhPes+b4QId6UxMqq1KL8+KLSnNTi
	Q4ymwCCYyCwlmpwPTHh5JfGGxiZmRpZG5oYWRsbmSuK8SvZtIUIC6YklqdmpqQWpRTB9TByc
	Ug2MQXLCESfWZ/d4PEsS0TztU37FYmtjyexCpWKzPwUGacn7Ts51lHh7L/Io6+GSaStv9DR/
	cLqwsW4Ohx1/3+UJhhOcX5n8WGTbVNg2qeD86u+/jr1YvdSnV0ykvVJDw3Cd+PX//dZ2u/Nj
	brxQyXhwrHtKz7ddpyJfVwSu0bpqny54tb7n7pc6JZbijERDLeai4kQALy7ViUADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 08:22 PM, Viresh Kumar wrote:
> On 20 January 2015 at 13:53, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> But, the frequency of OPPs is only used for devfreq ondemand governor.
>> After deciding the proper frequency of memory bus on ondemand governor,
>> exynos-bus.c (exynos memory bus frequency driver) use the frequency table
>> of memory bus blocks on below to change the clock rate of memory bus block.
> 
>> Firs of all,
>> I explain the hierarchy of Exynos memory buses.
>>
>> For example of Exynos3250 memory bus,
>> This patch divide the memory bus group according to power rail (regulator).
>> - MIF (Memory Interface ) memory bus group uses the VDD_MIF regulator.
>> - INT (Internal) memory bus group uses the VDD_INT regulator.
>>
>> Each memory bus group contains only one power rail(regulator) and one more memory bus blocks as follwing:
>>
>> - MIF memory bus group
>> power rail(VDD_MIF)-->|--- memory bus for DMC (Dynamic Memory Controller) block (dmc clock)
>>
>> - INT memory bus group
>>                       |--- memory bus for PERI block (aclk_100 clock)
>>                       |
>>                       |--- memory bus for DISPLAY block (aclk_160 clock)
>>                       |
>>                       |--- memory bus for ISP block (aclk_200 clock)
>>                       |
>>                       |--- memory bus for GPS block (aclk_266 clock)
>> power rail(VDD_INT)-->|
>>                       |--- memory bus for MCUISP block (aclk_400_mcuisp clock)
>>                       |
>>                       |--- memory bus for Leftbus block (gdl clock)
>>                       |
>>                       |--- memory bus for Rightbus block (gdr clock)
>>                       |
>>                       |--- memory bus for MFC block (mfc clock)
>>
>>
>> Exynos3250 has following table for INT memory bus group:
>> All clocks of INT memory bus group have to contain the same entry count
>> againt the number of 'virtual freqw'. So, each memory bus clock could have duplicate clocks.
>>
>> ------------------------------------------------------------------------
>> Level|virtual freq|PERI's clk|Display's clk|ISP's clk|GPS's clk| voltage|
>> ------------------------------------------------------------------------
>> L6   |400000      |100000    |200000       |200000   |300000   | 95000  |
>> L5   |200000      |100000    |160000       |200000   |200000   | 95000  |
>> L4   |133000      |100000    |100000       |100000   |133000   | 92500  |
>> L3   |100000      |100000    |80000        |80000    |100000   | 85000  |
>> L2   |80000       |50000     |80000        |50000    |50000    | 85000  |
>> L1   |50000       |50000     |50000        |50000    |50000    | 85000  |
>> -------------------------------------------------------------------------
>> (Except for mcuisp, leftbus, rightbus, mfc block)
>>
>> This table is used for devfreq ondemand governor as following:
>> 1. ondemand governor in devfreq use the 'virtual freq' to devcide the proper
>>    frequency for memory bus.
>> 2. ondemand governor executes the *_target() function to set clock rate and voltage.
>> 3. *_target() function in exynos-bus.c changes the clock rate of {PERIS|Display|ISP|GPS} clk
>>    according to decided 'Level' by devfreq ondemand governor.
> 
> I see..
> 
> Please confirm if my understanding is correct.
> - mem-bus-group: all blocks sharing a regulator
> - mem-bus-block: individual blocks managing their clock rate

Right and mem-bus-blcoks are included in a mem-bus-group.

> 
> What you do in kernel is register group as a device (with virtual OPPs)
> and then manage blocks within the driver. And so you need to do this
> dummy mapping of virtual to physical frequencies.

Right.

> 
> It *may* not have done it this way, if I was to design this driver.
> 
> Each bus-block is a separately controllable device and so must be registered
> separately. In that case all bus-blocks will have separate OPP tables and
> all this dummy-v2p mapping will go away.

If each bus-block has separate regulator independently, each bus-block can be registered
separately. But, exynos bus-blocks in mem-bus-group share the same regulator.

> 
> I believe that you are over complicating stuff without any need..
> 
> --
> viresh
> 

Best Regards,
Chanwoo Choi
