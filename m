Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935487Ab3DHMCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:02:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22020 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935112Ab3DHMCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:02:46 -0400
X-AuditID: cbfee68e-b7f946d000001e37-54-5162b1e5ee28
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'amit daniel kachhap'" <amit.daniel@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        cpufreq@vger.kernel.org,
        "'Inderpal Singh'" <inderpal.singh@linaro.org>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
 <2949363.nNl2A6XIoS@vostro.rjw.lan>
 <CADGdYn7ZRCSymU7k3Sn4mbS6B=dxy1N+vhQuyiFnhOQLLzrTbw@mail.gmail.com>
In-reply-to: <CADGdYn7ZRCSymU7k3Sn4mbS6B=dxy1N+vhQuyiFnhOQLLzrTbw@mail.gmail.com>
Subject: RE: [PATCH V5 0/4] cpufreq: exynos5440: support for cpufreq driver
Date: Mon, 08 Apr 2013 21:02:44 +0900
Message-id: <2d0501ce3450$fac4e9c0$f04ebd40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac40NDMQV/zqw310SRaxOAfowhiquQAGuSLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t8zQ92nG5MCDaa18lg0XA2xeNr0g91i
	xeQP7BabHl9jtbi8aw6bxefeI4wWM87vY7K4fZnXon9hL5PF4TftrBbHZixhtNj41cOBx6Ol
	uYfN4861PWwem5fUe/RtWcXo8WhxC6PH501yAWxRXDYpqTmZZalF+nYJXBmHus8zFuyUqrjy
	sZ+1gbFDpIuRk0NCwERiw6Hl7BC2mMSFe+vZQGwhgWWMEo1PvGBqeq7sBqrhAopPZ5S4svQL
	G4Tzl1Fi3bm7LCBVbAIaEoffPwObJCIQJfH0znQWkCJmgUnMEq8eLWWE6NjMKLFr4QxmkCpO
	gWCJl5u+M3UxcnAIC3hLPJ2dAxJmEVCV+LR7OxOIzStgK3Hq7y0oW1Dix+R7YMuYBbQk1u88
	zgRhy0tsXvOWGWSMhIC6xKO/uhA3GEk8m3uNEaJERGLfi3eMECUzOSRuikFsEpD4NvkQC0RY
	VmLTAWaIfyUlDq64wTKBUWIWkr2zkOydhWTvLCQLFjCyrGIUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIife+HYw3D1gfYkwGWj+RWUo0OR+YLvJK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBirqm5x2ad4k2brti0H800m2yh0zbp3K+Lqp5cf
	Ao7o3HrG+Ne7hYtFRElGeqvXBc5/17y9L6sc2xaiMKtdoMl2lkmPWduVU6sZ06cEVp5+flup
	Ikv8YKT95UlCyQILLwlFrdQtONlqGPaOffWNOZXd/VGM22/zq/6Z8ZdJbdYE9xw7kYWXLJVY
	ijMSDbWYi4oTAVSxXH4NAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQd2nG5MCDdacYLVouBpi8bTpB7vF
	iskf2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rx+zKvRf/CXiaLw2/aWS2OzVjCaLHxq4cDj0dL
	cw+bx51re9g8Ni+p9+jbsorR49HiFkaPz5vkAtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AuVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jFmHOo+z1iwU6riysd+1gbGDpEuRk4OCQETiZ4ru9khbDGJC/fWs3UxcnEI
	CUxnlLiy9AuU85dRYt25uywgVWwCGhKH3z8D6xARiJJ4emc6C0gRs8AkZolXj5YyQnRsZpTY
	tXAGM0gVp0CwxMtN35m6GDk4hAW8JZ7OzgEJswioSnzavZ0JxOYVsJU49fcWlC0o8WPyPbBl
	zAJaEut3HmeCsOUlNq95ywwyRkJAXeLRX12IG4wkns29xghRIiKx78U7xgmMQrOQTJqFZNIs
	JJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4pTyT2sG4ssHiEKMAB6MSD6/k
	j8RAIdbEsuLK3EOMEhzMSiK8hxcnBQrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjDd5ZXE
	GxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD48SdGqWaz5lO7l3k
	3VR2Zp/xzW+77+U/rXRK36MhMv3lqhbb1yeeb1td+sy/o/jxhSeFj8zuPFkeIfdkbXzFiR1K
	dT+qBASz95y2WKHxw67m+GfTc+Hv3G7/naxitMb9G9+GT2/2CM6Lv3JsyqKJhwUP5/S7y/p4
	hmyeP1eO8WjQ/e+3qkx7t51QYinOSDTUYi4qTgQAi/c19m0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amit daniel kachhap wrote:
> 
> On Fri, Apr 5, 2013 at 6:08 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, March 28, 2013 01:35:18 PM Amit Daniel Kachhap wrote:
> >> Submitting the V5 version of exynos5440 cpufreq driver. This patchset
> addresses
> >> all the coding and design concerns raised especially by Viresh.
> >>
> >> Changes in V5:
> >> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
> >> * Fixed all coding and comments issue raised by Viresh.
> >>
> >> Changes in V4:
> >> * Added dev_err logs instead of pr_err.
> >> * Used the devm_ioremap_resource API.
> >> * Implemented several coding guidelines and minor error comments from
> Sylwester,
> >>   Russell and Viresh.
> >>
> >> Changes in V3:
> >> * Converted the driver to probe based as suggested by Viresh. This is
> also
> >>   beneficial for multiplatform kernel.
> >> * Other coding guidelines related changes.
> >> * Moved the DT node outside cpu0 node as the driver is now a platform
> >>   driver.
> >>
> >> Changes in V2:
> >> * Added OPP library support to parse DT parameters.
> >> * Removed a hack to handle interrupts in bootup.
> >> * Implemented other review comments from Viresh and Inder.
> >>
> >> All these patches are dependent on Thomas Abraham common clock patches.
> >> (http://www.mail-archive.com/linux-samsung-
> soc@vger.kernel.org/msg15860.html)
> >> This whole patch series is based on 3.9-rc4.
> >>
> >> Amit Daniel Kachhap (4):
> >>   cpufreq: exynos: Add cpufreq driver for exynos5440
> >>   cpufreq: exynos: Remove error return even if no soc is found
> >>   arm: exynos: Enable OPP library support for exynos5440
> >>   arm: dts: Add cpufreq controller node for Exynos5440 SoC
> >>
> >>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   28 ++
> >>  arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
> >>  arch/arm/mach-exynos/Kconfig                       |    2 +
> >>  drivers/cpufreq/Kconfig.arm                        |    9 +
> >>  drivers/cpufreq/Makefile                           |    1 +
> >>  drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
> >>  drivers/cpufreq/exynos5440-cpufreq.c               |  474
> ++++++++++++++++++++
> >>  7 files changed, 527 insertions(+), 1 deletions(-)
> >>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-
> exynos5440.txt
> >>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c
> >
> > Is this for me or the Samsung tree?
> >
> > If it's for me, I need ACKs from the Samsung tree maintainers.  Also,
> please
> > address the Viresh's comments.
> >
> > Thanks,
> > Rafael
> >
> Hi Rafael,
> 
> I submitted the V6 version with all comments from Viresh addressed.
> 
> Hi Kukjin Kim,
> 
> Any suggestion on how this patch should be merged. In my opinion it
> should go via Rafael's tree as this patch uses some fixes present in
> Rafael's tree like modified cpufreq_notify_transition API.
> 
Yes, I agree. The v6 series including resending 1/4 patch looks good to me.
But the patch V6 4/4 would be sent to upstream via samsung tree to avoid
useless merge conflicts and I think, it's possible.

So Rafael, please take 1/4 ~ 3/4 patches in your tree with my ack.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

If any problems, please let me know.

Thanks.

- Kukjin

