Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbbATIXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 03:23:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43217 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATIXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 03:23:46 -0500
X-AuditID: cbfee68e-f79b46d000002b74-c1-54be108f5e40
Message-id: <54BE108F.8090506@samsung.com>
Date: Tue, 20 Jan 2015 17:23:43 +0900
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
In-reply-to: <CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkULdfYF+IwcS9BhaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJu8f3bNzaLVbv+MFps/OrhIOixZt4aRo+ds+6yeyze85LJY9OqTjaPO9f2sHls
	XlLv0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBmLFjsVPDatONp+jq2BcZd8FyMnh4SAicTk
	Gx9YIWwxiQv31rN1MXJxCAksZZR41tbNBFN06NYRZojEIkaJOaebWSGc14wSi84cBaviFdCS
	mDJxG5jNIqAqca/1K9hYNqD4/hc32EBsUYEwiZXTr7BA1AtK/Jh8D8jm4BABqnl5MxVkJrPA
	BDaJhh9vwOqFBfIkTj26AbW5l0mi6ck5sASnQLBE99pV7CA2s4C6xKR5i5ghbHmJzWveMkOc
	vZJDYuo1FoiDBCS+TT4EtkxCQFZi0wGoEkmJgytusExgFJuF5KRZSKbOQjJ1ASPzKkbR1ILk
	guKk9CIjveLE3OLSvHS95PzcTYzAmD/971nfDsabB6wPMQpwMCrx8L5ctTdEiDWxrLgy9xCj
	KdAVE5mlRJPzgYklryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxlim1d+Zgyqd+JNTPn/wvXL+NNdN3S0XbredldqxMdQg5GT/qbiQ7Cr/jSL8yQd/
	C/2f/VvK5ELTrn93LDjUZvvMv17k+65H4fwi84ALpyf9zzu2v+hn+FIpE67G9Iab+1nnfnvU
	FvTX5XTTG9WLaZvqBbd/Ck/e8zamb52wk3jrplo3leMXrJRYijMSDbWYi4oTATDmcV70AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd1+gX0hBr9Wq1k8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xfdv39gsVu36w2ix8auHg6DHmnlrGD12zrrL7rF4z0smj02rOtk87lzbw+ax
	eUm9R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXm
	ptoqufgE6Lpl5gB9oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWLTY
	qeCxacXR9nNsDYy75LsYOTkkBEwkDt06wgxhi0lcuLeerYuRi0NIYBGjxJzTzawQzmtGiUVn
	jjKBVPEKaElMmbgNzGYRUJW41/qVFcRmA4rvf3GDDcQWFQiTWDn9CgtEvaDEj8n3gGwODhGg
	mpc3U0FmMgtMYJNo+PEGrF5YIE/i1KMbzBDLepkkmp6cA0twCgRLdK9dxQ5iMwuoS0yat4gZ
	wpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBKeWZ
	1A7GlQ0WhxgFOBiVeHgd1u4NEWJNLCuuzD3EKMHBrCTC68+xL0SINyWxsiq1KD++qDQntfgQ
	oykwCCYyS4km5wPTXV5JvKGxiZmRpZG5oYWRsbmSOK+SfVuIkEB6YklqdmpqQWoRTB8TB6dU
	AyNbDova7LXVl9ueBv/zrm4/sWTlUx1xx1OTe7wVt6zKOxAj1fhyhuBciXbJAz3aLq1hDA5s
	LGdnRq+7eu/1t6iI+/cVr5rpv9/NPX+Gt8dKp7fv17x86uA6O23rk5+K3R/v/poSfcX0oAmv
	ltmcMmEH9fbU5/+t779MO5r27DF30pInXCZ/K7cpsRRnJBpqMRcVJwIAMYa1Yz8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

I explained the relation between memory bus group and memory bus block on following patch[1].
- [1] https://lkml.org/lkml/2015/1/8/642

On 01/20/2015 04:19 PM, Viresh Kumar wrote:
> On 9 January 2015 at 02:48, Rob Herring <robherring2@gmail.com> wrote:
>> Adding Viresh.
> 
> Sorry for being too late, I was very busy with other cpufreq stuff I was doing
> and saved this thread for later as it required me to understand it properly..
> 
>>> +Required properties for memory bus block:
>>> +- clock-names : the name of clock used by the memory bus, "memory-bus".
>>> +- clocks : phandles for clock specified in "clock-names" property.
>>> +- #clock-cells: should be 1.
>>> +- frequency: the frequency table to support DVFS feature.
>>
>> So you have just defined a new OPP table format. We already have one
>> and Viresh is working to create a more extendable one. He asked about
>> what's needed in devfreq, so Viresh here you go. :)
> 
> I failed to understand what's new here, probably I need more clarity on
> what we are doing here..
> 
> So, this is what I see from OPPs point of view, everything else stripped out.
> 
>>> +       memory_bus_int: memory_bus@1 {
> 
>>> +               operating-points = <
>>> +                       400000 950000
>>> +                       200000 950000
>>> +                       133000 925000
>>> +                       100000 850000
>>> +                       80000  850000
>>> +                       50000  850000>;
> 
> So these are the OPPs your "groups" support and below ones are
> the frequencies that each block will support. Right ?

Right.
But, the frequency of OPPs is only used for devfreq ondemand governor.
After deciding the proper frequency of memory bus on ondemand governor,
exynos-bus.c (exynos memory bus frequency driver) use the frequency table
of memory bus blocks on below to change the clock rate of memory bus block.

> 
>>> +               blocks {
> 
>>> +                               frequency = <
>>> +                                       100000
>>> +                                       100000
>>> +                                       100000
>>> +                                       100000
> 
> Why this replication here ?

Firs of all,
I explain the hierarchy of Exynos memory buses.

For example of Exynos3250 memory bus,
This patch divide the memory bus group according to power rail (regulator).
- MIF (Memory Interface ) memory bus group uses the VDD_MIF regulator.
- INT (Internal) memory bus group uses the VDD_INT regulator.

Each memory bus group contains only one power rail(regulator) and one more memory bus blocks as follwing:

- MIF memory bus group                     
power rail(VDD_MIF)-->|--- memory bus for DMC (Dynamic Memory Controller) block (dmc clock)

- INT memory bus group
                      |--- memory bus for PERI block (aclk_100 clock)
                      |
                      |--- memory bus for DISPLAY block (aclk_160 clock)
                      |  
                      |--- memory bus for ISP block (aclk_200 clock)
                      |
                      |--- memory bus for GPS block (aclk_266 clock)
power rail(VDD_INT)-->|
                      |--- memory bus for MCUISP block (aclk_400_mcuisp clock)
                      |
                      |--- memory bus for Leftbus block (gdl clock)
                      |
                      |--- memory bus for Rightbus block (gdr clock)
                      |
                      |--- memory bus for MFC block (mfc clock)


Exynos3250 has following table for INT memory bus group:
All clocks of INT memory bus group have to contain the same entry count
againt the number of 'virtual freqw'. So, each memory bus clock could have duplicate clocks.

------------------------------------------------------------------------
Level|virtual freq|PERI's clk|Display's clk|ISP's clk|GPS's clk| voltage|
------------------------------------------------------------------------
L6   |400000      |100000    |200000       |200000   |300000   | 95000  |
L5   |200000      |100000    |160000       |200000   |200000   | 95000  |
L4   |133000      |100000    |100000       |100000   |133000   | 92500  |
L3   |100000      |100000    |80000        |80000    |100000   | 85000  |
L2   |80000       |50000     |80000        |50000    |50000    | 85000  |
L1   |50000       |50000     |50000        |50000    |50000    | 85000  |
-------------------------------------------------------------------------
(Except for mcuisp, leftbus, rightbus, mfc block)

This table is used for devfreq ondemand governor as following:
1. ondemand governor in devfreq use the 'virtual freq' to devcide the proper
   frequency for memory bus. 
2. ondemand governor executes the *_target() function to set clock rate and voltage.
3. *_target() function in exynos-bus.c changes the clock rate of {PERIS|Display|ISP|GPS} clk
   according to decided 'Level' by devfreq ondemand governor.

> 
>>> +                                       50000
>>> +                                       50000>;
>>> +                       };
> 
> How are the above two tables (operating-points and frequency) related
> here? What about the voltages at which these frequencies are possible ?

I explained it on the upper.

> 
>>> +                       display_block: memory_bus_block2 {
> 
>>> +                               frequency = <
>>> +                                       200000
>>> +                                       160000
>>> +                                       100000
>>> +                                       80000
>>> +                                       80000
>>> +                                       50000>;
>>> +                       };
> 
>>> +                       isp_block: memory_bus_block3 {
> 
>>> +                               frequency = <
>>> +                                       200000
>>> +                                       200000
>>> +                                       100000
>>> +                                       80000
>>> +                                       50000
>>> +                                       50000>;
>>> +                       };
> 
>>> +                       gps_block: memory_bus_block4 {
> 
>>> +                               frequency = <
>>> +                                       300000
>>> +                                       200000
>>> +                                       133000
>>> +                                       100000
>>> +                                       50000
>>> +                                       50000>;
>>> +                       };
> 
> same for others as well..

I explained it on the upper.

Best Regards,
Chanwoo Choi
