Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbaLHLFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:05:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13748 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbaLHLFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:05:05 -0500
X-AuditID: cbfee68f-f791c6d000004834-15-548585de776b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        linux-fbdev@vger.kernel.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <19160360.7uJRUqlDQg@vostro.rjw.lan> <548584CC.7010603@ti.com>
In-reply-to: <548584CC.7010603@ti.com>
Subject: Re: [PATCH] video / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Date: Mon, 08 Dec 2014 20:06:30 +0900
Message-id: <000901d012d7$0509a090$0f1ce1b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAS1jN+vLr5ttVhT0ezURh9GkHNhgAAKvvQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zQ917ra0hBjOviVhcXniJ1eJE3wdW
	i8u75rBZfO49wmix7uELJoszp4ES6+ffYnNg93h14Q6Lx5ar7SwefVtWMXocv7GdyePzJrkA
	1igum5TUnMyy1CJ9uwSujMNb7zEWtHNWNN57ztrAOJG9i5GTQ0LARGLzqbnMELaYxIV769lA
	bCGBZYwSayfxwtQsvf4AKM4FFJ/OKNF46AIThPOLUeLXlJVg3WwCahJfvhwGmyoiEClx88EF
	sEnMAm8ZJSbfEehi5ABq8JJ4+bkaJMwJVP5z/Qo2kLCwgKfE6WklIGEWAVWJ0z1XwCbyCthK
	fD66gQnCFpT4MfkeC0g5s4C6xJQpuRDD5SU2r3nLDBKWAAo/+qsLsd9I4u/eu4wQJSIS+168
	YwQ5WELgEbvE+Rn7GSFWCUh8m3yIBaJXVmLTAWgoSEocXHGDZQKjxCwki2chLJ6FZPEsJBsW
	MLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJ2v4djHcPWB9iFOBgVOLhXfCgJUSINbGs
	uDL3EKMp0EETmaVEk/OBqSGvJN7Q2MzIwtTE1NjI3NJMSZx3odTPYCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MVRcCVBR/Zkcp9PFH+l2TvbdLPOxl1gOZnTIcX7c3T3Q9Y8q1RPLA5cn7
	k9Rtd/gujnh58fvqZdu+fXjHzd5wX5r5hsvEuWfZ7H6HNDg/eN/MfdLc2WVb6uG4fb6nUnu/
	//qSzWzy47qu7f31fNu/ZanGnlz0+mEe2wNTv92bK10+ODjdVSz4osRSnJFoqMVcVJwIAIad
	0c/VAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO691tYQgxcH+S0uL7zEanGi7wOr
	xeVdc9gsPvceYbRY9/AFk8WZ00CJ9fNvsTmwe7y6cIfFY8vVdhaPvi2rGD2O39jO5PF5k1wA
	a1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozDW+8xFrRzVjTee87awDiR
	vYuRk0NCwERi6fUHbBC2mMSFe+uBbC4OIYHpjBKNhy4wQTi/GCV+TVnJDFLFJqAm8eXLYbBu
	EYFIiZsPLoB1Mwu8ZZSYfEegi5EDqMFL4uXnapAwJ1D5z/Ur2EDCwgKeEqenlYCEWQRUJU73
	XAGbyCtgK/H56AYmCFtQ4sfkeywg5cwC6hJTpuRCDJeX2LzmLTNIWAIo/OivLsR+I4m/e+8y
	QpSISOx78Y5xAqPQLCSDZiEMmoVk0CwkHQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BCeFZ1I7GFc2WBxiFOBgVOLhXfCgJUSINbGsuDL3EKMEB7OSCG9iXGuIEG9KYmVValF+fFFp
	TmrxIUZToDcnMkuJJucDE1ZeSbyhsYmZkaWRmYWRibm5kjjvjZu5IUIC6YklqdmpqQWpRTB9
	TBycUg2MjM89ZQPWrfRMPf6ofontZK7bfEoLZx58n1dpcUTTWcZkbVz6CeVpF3vjrDgfB2iu
	eJsa5jiraPdEw0M+ciYxLXlp6enfsxnXv/KZ+zYzJ4C/NdHlwJka7YnZryIcPuQ/Fnf7X69v
	8qGvuOmk76W7JwN+3nwzf2Gm5G7GWcJ+rOtOVgf/6v+pxFKckWioxVxUnAgAxkG0VyADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 08, 2014 8:00 PM, Tomi Valkeinen wrote
> 
> On 06/12/14 04:36, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> > selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> > depending on CONFIG_PM_RUNTIME may now be changed to depend on
> > CONFIG_PM.
> >
> > The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> > replaced with CONFIG_PM too.
> >
> > Make these changes in 2 files under drivers/video/.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >
> > Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> > PM_SLEEP is selected) which is only in linux-next at the moment (via the
> > linux-pm tree).
> >
> > Please let me know if it is OK to take this one into linux-pm.
> 
> Does not seem to conflict with fbdev changes, so:
> 
> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

For drivers/video/fbdev/s3c-fb.c,

Acked-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> 
>  Tomi
> 


