Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3EFLmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:42:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52498 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3EFLmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:42:16 -0400
X-AuditID: cbfee68d-b7f016d000007930-b3-51879716e6d1
From: "myungjoo.ham" <myungjoo.ham@samsung.com>
To: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Rajagopal Venkat'" <rajagopal.venkat@linaro.org>
Cc: "'Kevin Hilman'" <khilman@linaro.org>,
        "'Alan Stern'" <stern@rowland.harvard.edu>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1366205301-4249-1-git-send-email-rajagopal.venkat@linaro.org>
 <8888976.pxWaKvWiK0@vostro.rjw.lan>
In-reply-to: <8888976.pxWaKvWiK0@vostro.rjw.lan>
Subject: RE: [PATCH V3] PM / devfreq: tie suspend/resume to runtime-pm
Date: Mon, 06 May 2013 20:42:14 +0900
Message-id: <003601ce4a4e$c0bb54d0$4231fe70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLKFadH2XJRzWSCpsPWURe7Ip/IjgGnBuR9lvMznDA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsWyRsSkWFdsenugwZ8fshZfD69gtHh/6Bmz
	xeVdc9gsPvceYbSYcvgLi0Xrsn3MFv0Le5ksJvy+wObA4XHn2h42j9v/HjN7zL77g9Hj0eIW
	Ro/Pm+QCWKO4bFJSczLLUov07RK4MmYsMS54L1px/Z5BA+M5wS5GTg4JAROJ5t+HWCBsMYkL
	99azdTFycQgJLGWUWD/hHDtM0ZNPD1kgEtMZJeZuu80I4fxmlJh48TErSBWbgL7Enmu/GEFs
	EYFoiRdNO5lBipgFDjNKPJj/E6iIA6ijQOLotzKQGk4BA4mF2z6wgdjCAm4St7u2g53BIqAq
	8eH2RDCbV8BS4kzvVyhbUOLH5HssIGOYBdQlpkzJBQkzC2hLPHl3gRXiUAWJHWdfQ51gJTHt
	x0oWiBoRiX0v3oHdLCHwlV1i3cJ77BC7BCS+TT4ENlNCQFZi0wFmiDmSEgdX3GCZwCgxC8nm
	WQibZyHZPAvJhgWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxAmP49L9nvTsYbx+wPsSY
	DLR9IrOUaHI+MAXklcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoExRu7q5x1BcodseayD64P+fZppYVb2wXbFJ/Nj0WW5e/pbZac2Hk8sa+d4GzFv
	p4XkzpYPeyuPFD7zvVlecjmx8WGZpKnH96INbwS+20nde6QVFbe7+Qurz//Fyz8yLXPLtIjL
	iOQx/LumpDQjcdXcO8WXhb9qhZ/db3PB69/6yvO8qhqK5SJKLMUZiYZazEXFiQDu025m9wIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQV2x6e2BBnvuiFh8PbyC0eL9oWfM
	Fpd3zWGz+Nx7hNFiyuEvLBaty/YxW/Qv7GWymPD7ApsDh8eda3vYPG7/e8zsMfvuD0aPR4tb
	GD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gxY4lxwXvRiuv3
	DBoYzwl2MXJySAiYSDz59JAFwhaTuHBvPVsXIxeHkMB0Rom5224zQji/GSUmXnzMClLFJqAv
	sefaL0YQW0QgWuJF005mkCJmgcOMEg/m/wQq4gDqKJA4+q0MpIZTwEBi4bYPbCC2sICbxO2u
	7WDbWARUJT7cnghm8wpYSpzp/QplC0r8mHyPBWQMs4C6xJQpuSBhZgFtiSfvLrBCHKogsePs
	a6gTrCSm/VjJAlEjIrHvxTvGCYxCs5BMmoUwaRaSSbOQdCxgZFnFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJEZwgnkntYFzZYHGIUYCDUYmHt+BJW6AQa2JZcWXuIUYJDmYlEV6fvUAh3pTE
	yqrUovz4otKc1OJDjMlAf05klhJNzgcmr7ySeENjEzMjSyNzQwsjY3PShJXEeQ+0WgcKCaQn
	lqRmp6YWpBbBbGHi4JRqYOxbdP3BmcXBVkITDl2+xCCcM7/a4OT17Xti2M/8Eju5K+b+SbOf
	W1N85Y37Wdn44vXup+mxaEhWyGZ4sDB9DuJepHfpHt9T270Hn8+YYaCT5RPGm6d5OsmJlyHy
	0iLv7sP/7v722S+Q6vnxBcP367mS649u6Hb8yXDo3nrjc4qybaVz3tV9DlBiKc5INNRiLipO
	BACzVESPVAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> On Wednesday, April 17, 2013 06:58:21 PM Rajagopal Venkat wrote:
> > Devfreq core runtime suspend/resume of a device is explicitly handled 
> > by devfreq driver using devfreq_suspend_device() and
> > devfreq_resume_device() apis typically called from runtime 
> > suspend/resume callbacks. This patch aims to take away this from 
> > devfreq drivers and handle it from runtime-pm core. So that devfreq 
> > core runtime suspend/resume of a device is automatically done with 
> > runtime pm suspend/resume. The devfreq drivers shouldn't be concerned 
> > on when to suspend/resume the devfreq.
> 
> I agree, but perhaps there's a better way to achieve that than fumbling in the PM core?
> 
> Did you consider using a PM domain for that?

As genpd_add_device seems to allow a device to register multiple domains, it seems fine. We need to ensure that there is only one device for the devfreq domain though.

pm_domain seems to be an overkill; however, the excessive overhead seems to be there only for register/unregister and that seems acceptable.

> 
> > This patch is targeted to handle devfreq core load monitoring runtime 
> > suspend/resume only. Not the actual hardware itself.
> > All the resources like clocks and regulators must still be handled by 
> > device driver using runtime-pm. The sequence of devfreq and device 
> > runtime suspend/resume is,
> > 
> > pm_runtime_suspend(dev) will first suspend device devfreq (if 
> > available) before device is suspended to ensure devfreq load 
> > monitoring is stopped and no device resources like clocks are accessed 
> > while device suspend is in progress.
> > 
> > pm_runtime_resume(dev) will resume device devfreq(if available) after 
> > device is resumed to ensure device resources like clocks are ready for 
> > use.
> > 
> > As devfreq runtime suspend/resume is done automatically from runtime 
> > core, this patch removes the existing devfreq_suspend_device() and
> > devfreq_resume_device() apis.
> > 
> > Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> 
> I'm having a problem with this patch, because it's adding overhead into
> rpm_suspend() and rpm_resume() for all devices, even though many of them may not use devfreq.  Worse yet, there are systems in which devfreq will never be used at all.
> 
> Thanks,
> Rafael

I thought about having the polling loop to check if the device is running or not before getting usage statistics. But we still need something to notify resume.


> 
> 
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
>

Cheers,
MyungJoo


