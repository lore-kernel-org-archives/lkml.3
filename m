Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaFXLCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:02:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59385 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaFXLCp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:02:45 -0400
X-AuditID: cbfee690-b7fb56d000003439-be-53a95acb19b9
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        mark.brown@linaro.org, "'Tomasz Figa'" <t.figa@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        michal.simek@xilinx.com
References: <53A05E2D.6020702@samsung.com>
 <1403019164-12514-1-git-send-email-t.figa@samsung.com>
 <5027740.B7iVUcUX2T@wuerfel> <53A0B27E.5010708@gmail.com>
 <20140618082653.GN21030@lee--X1>
In-reply-to: <20140618082653.GN21030@lee--X1>
Subject: RE: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon
 devices
Date: Tue, 24 Jun 2014 16:33:28 +0530
Message-id: <007901cf8f9b$fe27ae70$fa770b50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKN9QGh9175x+dQQ3DHKBd0w/cN3wF7DLOkAp0PCdoB7oYCCQKjQGlkmb3511A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsWyRsSkRvd01Mpgg+bn7BZ/Jx1jt1g26S6b
	xfddX9gtehdcZbO4//Uoo8Wmx9dYLS7vmsNmMeP8PiaL25d5LXZcu8Vi8e5lhMXpblaL9TNe
	s1is2vWH0eLms+1MDvweLc09bB6/f01i9Ng56y67x51re9g85p0M9Ni8pN6jb8sqRo/Pm+Q8
	9n7+zRLAGcVlk5Kak1mWWqRvl8CVseLKV5aCZ5IV/Rt72RsYZ4p0MXJySAiYSGzd/J8RwhaT
	uHBvPVsXIxeHkMBSRomnn/4xwRT17u1hhEhMZ5T4tnoJK4Tzl1Hi6PU7LCBVbAK6Ek/ez2UG
	sUUEfCX27GhnAiliFtjALLHrczMLRMchRok559+wg1RxAnUcO7kEbIewQKhE/+42sG4WAVWJ
	090LwKbyClhKrD90kx3CFpT4MfkeUJwDaKq6xJQpuSBhZgFtiSfvLrBCnKogsePsa0aII/wk
	fm86wQxRIy4x6cFDdpAbJAQOcEh83PmEBWKXgMS3yYfAZkoIyEpsOsAMMUdS4uCKGywTGCVm
	Idk8C2HzLCSbZyHZsICRZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYLo4/e/ZhB2M9w5Y
	H2JMBto+kVlKNDkfmG7ySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoExfGeumsIr82iP6nX+SxmP3rbalH3Pd6/tglfZ3pLixQ/9Xy1PVV0hv59n
	/c/zSxUSZqw6rR9X8Lqwsj/ZybdT5dPRb61qp9a7eWTPtV/w7P/r9d/5O68J38/1aOPPWXmt
	Km5BrEWpeE2trtqH0w1/RJm4dG6lpJkX8f+0WG32innXldXH3msrsRRnJBpqMRcVJwIAbhgh
	sS0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQd1TUSuDDeY3WFv8nXSM3WLZpLts
	Ft93fWG36F1wlc3i/tejjBabHl9jtbi8aw6bxYzz+5gsbl/mtdhx7RaLxbuXERanu1kt1s94
	zWKxatcfRoubz7YzOfB7tDT3sHn8/jWJ0WPnrLvsHneu7WHzmHcy0GPzknqPvi2rGD0+b5Lz
	2Pv5N0sAZ1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0PlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowVV76yFDyTrOjf
	2MvewDhTpIuRk0NCwESid28PI4QtJnHh3nq2LkYuDiGB6YwS31YvYYVw/jJKHL1+hwWkik1A
	V+LJ+7nMILaIgK/Enh3tTCBFzAIbmCV2fW5mgeg4xCgx5/wbdpAqTqCOYyeXMIHYwgKhEv27
	28C6WQRUJU53LwCbyitgKbH+0E12CFtQ4sfke0BxDqCp6hJTpuSChJkFtCWevLvACnGqgsSO
	s68ZIY7wk/i96QQzRI24xKQHD9knMArNQjJpFsKkWUgmzULSsYCRZRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcDJ6Jr2DcVWDxSFGAQ5GJR7eiMAVwUKsiWXFlblAv3IwK4nwhoSvDBbi
	TUmsrEotyo8vKs1JLT7EaAr050RmKdHkfGCizCuJNzQ2MTc1NrU0sTAxs1QS5z3Yah0oJJCe
	WJKanZpakFoE08fEwSnVwJhz5U/Abr92vSOsk8/N0J7oUvNK42XRIzud0Oy/E9d+/XhC7UTd
	q7zJZ3QO9WvH7G1w1xK8GBjSsMxEi0uFpc6s89Nhf/8zyivv+rAcEQw/tMogquRy+4JPeRv+
	pH/+YSV58ZldE0+S7yMFha8Jj61CxYWTvp67s+OF/KpFEYsFVASnP7Ew71BiKc5INNRiLipO
	BAB5PJZ7XAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, June 18 2014, Lee Jones wrote:
> On Tue, 17 Jun 2014, Tomasz Figa wrote:
> > On 17.06.2014 17:42, Arnd Bergmann wrote:
> > > On Tuesday 17 June 2014 17:32:44 Tomasz Figa wrote:
> > >> Currently a syscon entity can be only registered directly through a
> > >> platform device that binds to a dedicated driver. However in
> > >> certain use cases it is desirable to make a device used with
> > >> another driver a syscon interface provider. For example, certain
> > >> SoCs (e.g. Exynos) contain system controller blocks which perform
> > >> various functions such as power domain control, CPU power
> > >> management, low power mode control, but in addition contain certain
> > >> IP integration glue, such as various signal masks, coprocessor
> > >> power control, etc. In such case, there is a need to have a
> > >> dedicated driver for such system controller but also share
> > >> registers with other drivers. The latter is where the syscon interface is helpful.
> > >>
> > >> This patch decouples syscon object from syscon driver, so that it
> > >> can be registered from any driver in addition to the original
> > >> "syscon" platform driver.
> 
> +1 for this approach.
> 
> Michal, Pankay,
>   Does it also suit your needs?
> 

Sorry for late reply. 
I tested this patch after changing exynos PMU to be a syscon provider and it's working well.
So if we can address Arnd's comments, this patch will be helpful in making exynos PMU a 
complete platform driver.

Thanks,
Pankaj Dubey

> > >> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> > >
> > > Hi Tomasz,
> > >
> > > This seems like a reasonable way of solving the problem, but I think
> > > there is an even better one that we have about in the past: if we
> > > promote syscon from a platform driver into a a drivers/base/ helper
> > > that is independent of the platform device matching, we can use call
> > > syscon_regmap_lookup_* for any device node, whether it's already
> > > bound to a driver or not, which do what you need. It would also make
> > > it easier to call the syscon code before the platform_device
> > > infrastructure gets initialized, which is something a number of
> > > people have asked for, e.g. for using regmap to do SMP bringup or
> > > for clock registration.
> >
> > Basically, unless I'm missing your point, this is what my patch does,
> > except that I don't move it to drivers/base/ and the registration
> > function I added require a pointer to struct device. Indeed,
> > decoupling it further from the driver model, by adding
> > of_syscon_register() should be useful for early users.
> 
> If agreed by Arnd, I think this work can be completed as a subsequent patch.
> 
> > Should I move this to drivers/base/, even though from current location
> > it can be used outside the platform driver anyway?
> 
> If I'm being honest with myself, I'd say that Syscon wasn't really an MFD driver.  I'm
> happy to keep it in there any continue maintaining it, but wouldn't block a move
> either.
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead Linaro.org │ Open source software
> for ARM SoCs Follow Linaro: Facebook | Twitter | Blog

