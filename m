Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188AbbAUGNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:13:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23245 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUGNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:13:00 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-d0-54bf436967e6
Message-id: <54BF4369.1060900@samsung.com>
Date: Wed, 21 Jan 2015 15:12:57 +0900
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
 <54BF2929.3090107@samsung.com>
 <CAKohpomrAtqedODuzaAe3qO_YppeOU+LYR45eEs0+KcHJKHcQA@mail.gmail.com>
In-reply-to: <CAKohpomrAtqedODuzaAe3qO_YppeOU+LYR45eEs0+KcHJKHcQA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkWDfTeX+IwZprhhaP1yxmstg4Yz2r
	xaT7E1gsXr8wtOh//JrZ4mzTG3aLTY+vsVpc3jWHzeJz7xFGixnn9zFZLL1+kcniduMKNovH
	K96yW7TuPcJu8f3bNzaLVbv+MFps/OrhIOixZt4aRo+ds+6yeyze85LJY9OqTjaPO9f2sHls
	XlLv0bdlFaPH501yARxRXDYpqTmZZalF+nYJXBn75nSzFdwTrXg3fSZzA+Ntri5GDg4JAROJ
	q3tsuhg5gUwxiQv31rN1MXJxCAksZZTYd+Y+C0TCRGJJdzcjRGIRo0Tv5bcsEM5rRol/+yaC
	VfEKaEk8n7yLDcRmEVCVaD3xgxHEZgOK739xAywuKhAmsXL6Fah6QYkfk++xgFwhAlTz8mYq
	yExmgQlsEg0/3oDVCwvkSZx6dIMZxBYSOMoicelTIojNKRAssevOO7A5zALqEpPmLWKGsOUl
	Nq95ywwySEJgKYdEy42HUAcJSHybfIgF4mVZiU0HmCE+k5Q4uOIGywRGsVlITpqFZOwsJGMX
	MDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiM+dP/nk3YwXjvgPUhRgEORiUe3heK+0OE
	WBPLiitzDzGaAl0xkVlKNDkfmFjySuINjc2MLExNTI2NzC3NlMR5X0v9DBYSSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXA2LrbbZKTweXPBTrulp+2/n2xf99hHYutbBNYzi3yCp4/hfOZ2Ll/
	V5y1atp8383LXCGxW2tb23PH59PYAlf0xnixz7O7mOLwUb+pPtiyhi8yRNpOtXbeVXfbpwuL
	T91Y8Psdn+fRG1K1Lw5fY95sx3T9aszikpmdMl+cJ4ueLC5VX7VwS/LaeCWW4oxEQy3mouJE
	ACUMBev0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jAd1M5/0hBgfmalg8XrOYyWLjjPWs
	FpPuT2CxeP3C0KL/8Wtmi7NNb9gtNj2+xmpxedccNovPvUcYLWac38dksfT6RSaL240r2Cwe
	r3jLbtG69wi7xfdv39gsVu36w2ix8auHg6DHmnlrGD12zrrL7rF4z0smj02rOtk87lzbw+ax
	eUm9R9+WVYwenzfJBXBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXm
	ptoqufgE6Lpl5gB9oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2Den
	m63gnmjFu+kzmRsYb3N1MXJySAiYSCzp7maEsMUkLtxbz9bFyMUhJLCIUaL38lsWCOc1o8S/
	fRNZQKp4BbQknk/exQZiswioSrSe+AHWzQYU3//iBlhcVCBMYuX0K1D1ghI/Jt8Dsjk4RIBq
	Xt5MBZnJLDCBTaLhxxuwemGBPIlTj24wg9hCAkdZJC59SgSxOQWCJXbdeQc2h1lAXWLSvEXM
	ELa8xOY1b5knMArMQrJiFpKyWUjKFjAyr2IUTS1ILihOSs810itOzC0uzUvXS87P3cQITinP
	pHcwrmqwOMQowMGoxMP7QnF/iBBrYllxZe4hRgkOZiURXkUJoBBvSmJlVWpRfnxRaU5q8SFG
	U2AITGSWEk3OB6a7vJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC1CKYPiYOTqkG
	RscV/lnqzcIa86bH2/DMmdDAPtvqVlnhm3NRwd7cNdfiP7teMUuW/jW1MsssJFdn/r7cfwe2
	fLZoVNM6Hyn7doOtfMsnnljZoq7ntab2F6YGNpw8Hh7rtmbz/par79WizU2S5vw5Pv23xZum
	mx/rnn6+8fjfzhOe5UZRCyJs36jKZ3CyHA9+qsRSnJFoqMVcVJwIANXVB5o/AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 01:37 PM, Viresh Kumar wrote:
> On 21 January 2015 at 09:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> If the clock will be stayed on highest voltage, will reduce
>> the considerable benefit of power-consumption.
> 
> But this is exactly what you must be doing right now as well..
> I think I didn't make it clear enough with an example. Let me
> try..
> 
> This is how I feel it should look like:
> 
>        memory_bus_int: memory_bus@1 {
>                // Regulator is shared for all below
>                blocks {
>                        peri_block: memory_bus_block1 {
>                                 operating-points = <
>                                         100000 850000
>                                         50000  850000>;
>                        };
> 
>                        display_block: memory_bus_block2 {
>                                 operating-points = <
>                                         200000 950000
>                                         160000 950000
>                                         100000 925000
>                                         80000  850000
>                                         50000  850000>;
>                        };
> 
>                        isp_block: memory_bus_block3 {
>                                 operating-points = <
>                                         200000 950000
>                                         100000 925000
>                                         80000  850000
>                                         50000  850000>;
>                        };
> 
>                        gps_block: memory_bus_block4 {
>                                 operating-points = <
>                                         300000 950000
>                                         200000 950000
>                                         133000 925000
>                                         100000 850000
>                                         50000  850000>;
>                        };
> 
> 
> Now suppose these are the requirements from all the blocks
> at any point of time:
> - block1: 100000 850000
> - block2: 100000 925000
> - block3: 80000  850000
> - block4: 133000 925000
> 
> Now, all of them can control freq separately and we don't need to
> worry for that. But regulator is shared between them. We can check
> what's the highest voltage requested at this point of time and can
> switch to that.
> 
> i.e. 925000 in this case. And that's not the highest possible one.
> And you will reach to similar conclusion with your current code as
> well I believe.
> 

OK, I understand.
I'll try to update exynos memory bus according to your comment.

Thanks
Chanwoo








