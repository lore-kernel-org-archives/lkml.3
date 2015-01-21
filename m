Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbbAUEVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:21:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15751 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbAUEVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:21:00 -0500
X-AuditID: cbfee68d-f79296d000004278-aa-54bf292a2e09
Message-id: <54BF2929.3090107@samsung.com>
Date: Wed, 21 Jan 2015 13:20:57 +0900
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
 <54BE3E10.2080906@samsung.com>
 <CAKohpontEntV48XqNcJq+euT9SdEjkgn5Pa=sSUpgM8mfKKCUA@mail.gmail.com>
In-reply-to: <CAKohpontEntV48XqNcJq+euT9SdEjkgn5Pa=sSUpgM8mfKKCUA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsWyRsSkWFdLc3+IwcxZ7BaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJu8f3bNzaLVbv+MFps/OrhIOixZt4aRo+ds+6yeyze85LJY9OqTjaPO9f2sHls
	XlLv0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBm7bjaxFlxgq7jy0L2BcR1rFyMnh4SAicTl
	/auYIWwxiQv31rOB2EICSxkldnaHw9TM2TsdqIYLKL6IUWLzuiesEM5rRolvE2YBZTg4eAW0
	JPZcLwMxWQRUJXrmGYD0sgFF97+4ATZTVCBMYuX0KywgNq+AoMSPyfdYQMpFgGpe3kwFmcgs
	MIFNouHHG7B6YYE8iVOPbkDtvcsscfXkOrAEp0CwxMxJ+8AeYBZQl5g0bxEzhC0vsXnNW7AG
	CYGlHBLvLk0AK2IREJD4NvkQ2DYJAVmJTQegHpaUOLjiBssERrFZSG6ahWTsLCRjFzAyr2IU
	TS1ILihOSi8y1CtOzC0uzUvXS87P3cQIjPfT/5717mC8fcD6EKMAB6MSD+8Lxf0hQqyJZcWV
	uYcYTYGumMgsJZqcD0wqeSXxhsZmRhamJqbGRuaWZkrivIpSP4OFBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MCoeb+dbWONnZXr94s0rljdFebdMKDok8pjns3P/Jp3dEyL/caxU0HfW/TZF
	+vfZMg7WlivbLS/t5y5M/H91lteXjsfz3eIXrfQv9Jv76s3qQ1dn7/3kNq1/qZ9F/wXG+5Ok
	BQ4sSmnMWvKI0W6baolB89WgI3o1hWbVYlcOOhcwPJHpiLyUtFCJpTgj0VCLuag4EQAliQ4B
	8gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV1Nzf0hBsdmWVs8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xfdv39gsVu36w2ix8auHg6DHmnlrGD12zrrL7rF4z0smj02rOtk87lzbw+ax
	eUm9R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXm
	ptoqufgE6Lpl5gB9oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2HWz
	ibXgAlvFlYfuDYzrWLsYOTkkBEwk5uydzgxhi0lcuLeerYuRi0NIYBGjxOZ1T1ghnNeMEt8m
	zAKq4uDgFdCS2HO9DMRkEVCV6JlnANLLBhTd/+IGG4gtKhAmsXL6FRYQm1dAUOLH5HssIOUi
	QDUvb6aCTGQWmMAm0fDjDVi9sECexKlHN5ghVt1llrh6ch1YglMgWGLmpH1ghzILqEtMmreI
	GcKWl9i85i3zBEaBWUh2zEJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwenk
	mdQOxpUNFocYBTgYlXh4XyjuDxFiTSwrrsw9xCjBwawkwqsoARTiTUmsrEotyo8vKs1JLT7E
	aAoMgYnMUqLJ+cBUl1cSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE08fEwSnV
	wHjR5P1/xr+pbtIG920n+a//eCGiZ1OaSJj4rzLXmNObQxWFlhhMYE7XeZWlH8D5K0fzRZyc
	UurfTVvEzE+kznpUKe99+WCkeY/18+Xy3U7x0RdX68Uost7+k57pe7fX85r12S0JzRX5HhbM
	S048iNIxu6YVlDyL+7hivKO4gm36FP84F8MSJZbijERDLeai4kQAVYXSnz0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 12:17 PM, Viresh Kumar wrote:
> On 20 January 2015 at 17:07, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> If each bus-block has separate regulator independently, each bus-block can be registered
>> separately. But, exynos bus-blocks in mem-bus-group share the same regulator.
> 
> This can be managed easily within the driver. Just stay the highest
> voltage requested.

If the clock will be stayed on highest voltage, will reduce
the considerable benefit of power-consumption.

I think it is DFS instead of DVFS. Is it right?

> I don't think its not manageable. But it will be much more convenient
> as that will show
> the correct picture and get rid of unnecessarily virtualizing things..

What is the correct picture? do you need more detailed explanation
of Exynos memory bus structure?

Thanks,
Chanwoo
