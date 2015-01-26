Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbbAZCLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 21:11:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16825 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbbAZCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 21:11:46 -0500
X-AuditID: cbfee691-f79b86d000004a5a-68-54c5a2606ead
Message-id: <54C5A260.7030103@samsung.com>
Date: Mon, 26 Jan 2015 11:11:44 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com
Cc: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v9 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
References: <298834569.29261422238011182.JavaMail.weblogic@epmlwas04d>
In-reply-to: <298834569.29261422238011182.JavaMail.weblogic@epmlwas04d>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkSDdh0dEQg771ShaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJusWrXH0YHfo8189YweuycdZfdY/Gel0wem1Z1snlsXlLv0bdlFaPH501yAexR
	XDYpqTmZZalF+nYJXBkbd01mL3jBVnFu5XbWBsa5rF2MnBwSAiYSC879ZoSwxSQu3FvP1sXI
	xSEksJRRYs2XaWwwRVf/HGSGSCxilHhyZyZYQkjgNaPE5F3xIDavgJbEp08PwOIsAqoSrevu
	MYHYbEDx/S9ugMVFBcIkVk6/wgJRLyjxY/I9MFtEQEbi6sbtLCALmAVa2STed+1lB0kIC6RK
	7Dk2kwVimZvE2gWTwQZxCrhLTN+yEyzOLKAuMWneImYIW15i85q3YJdKCEzkkPi5+zErxEUC
	Et8mHwJq4ABKyEpsOsAM8ZmkxMEVN1gmMIrNQnLTLCRjZyEZu4CReRWjaGpBckFxUnqRqV5x
	Ym5xaV66XnJ+7iZGYGSf/vds4g7G+wesDzEKcDAq8fBqNB4NEWJNLCuuzD3EaAp0xURmKdHk
	fGD6yCuJNzQ2M7IwNTE1NjK3NFMS59WR/hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgfFg
	40arGpY6NRYDfblkuSMpt/Z797O/7wg7/tOXkZUr6ofWygiBf2WKfZNW266Y+Kpwn8wetXt9
	lrph04+49vd/qKxtUBCK5PVwd24X5Z7w1CXW+BCT+J4Fkw2an2sq7i7ad770UsjVgOlRPS/1
	f/KyvTthfOVn5pUrKvxRy5wuPrkVuq1yqxJLcUaioRZzUXEiAAZ8WivnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd2ERUdDDO6skLR4vGYxk8XGGetZ
	LSbdn8Bi8fqFoUX/49fMFmeb3rBbbHp8jdXi8q45bBafe48wWsw4v4/JYun1i0wWtxtXsFk8
	XvGW3aJ17xF2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2LSqk81j85J6j74tqxg9Pm+SC2CP
	amC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6W0mh
	LDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsXHXZPaCF2wV51ZuZ21gnMva
	xcjJISFgInH1z0FmCFtM4sK99WxdjFwcQgKLGCWe3JnJBpIQEnjNKDF5VzyIzSugJfHp0wOw
	OIuAqkTruntMIDYbUHz/ixtgcVGBMImV06+wQNQLSvyYfA/MFhGQkbi6cTsLyAJmgVY2ifdd
	e9lBEsICqRJ7js1kgVjmJrF2wWSwQZwC7hLTt+wEizMLqEtMmreIGcKWl9i85i3zBEaBWUh2
	zEJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWnjmfQOxlUNFocYBTgYlXh4
	NRqPhgixJpYVV+YeYpTgYFYS4S2fAhTiTUmsrEotyo8vKs1JLT7EaAoMgonMUqLJ+cCUllcS
	b2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwJjqov1WZlu/+4x2pQ2H
	9qRfDj81d5v74h+sbltOs1a6tr9xfrLWa9uWLyWz17xKqLKuYhCXL0u7WnD5nMT75qmKJat5
	uSs45hn4ffWpC/RqD3sspXROIkZTTOdc3q2VT5ftrmN7ulT20V/P2T/OR4q+7zqTIGom89Rh
	tbGmWPvS49o2i/ubLJVYijMSDbWYi4oTAfWyOrAxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kukjin and Myungjoo,

On 01/26/2015 11:06 AM, MyungJoo Ham wrote:
>>   
>>  Chanwoo Choi wrote:
>>>
>> Hi,
>>
> 
> []
> 
>>>
>>> --
>>
>> Looks good to me.
>>
>> Myungjoo, shall I take DT changes in this series into Samsung tree?
>>
>> 4/7 ARM: dts: Add PPMU dt node for Exynos3250 SoC
>> 5/7 ARM: dts: Add PPMU dt node for Exynos4 SoCs
>> 6/7 ARM: dts: exynos: Add PPMU node for Exynos3250-based Rinato/Monk board
>> 7/7 ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board
> 
> Yes, you may take those. I am not so confident with taking DT patches, either.
> 
> However, Chanwoo has another updates following for this patchset.
> 
> After that, I guess we can merge chanwoo's patchset splitted.

I have minor fixup issue. I'll send next patchset(v10) right now.

Thanks for your review.

Best Regards,
Chanwoo Choi

