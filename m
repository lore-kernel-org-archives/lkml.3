Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaE1EfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:35:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28822 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaE1EfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:35:22 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-e0-53856787201c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Lorenzo Pieralisi'" <lorenzo.pieralisi@arm.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com>
 <1400227438-27155-1-git-send-email-chander.kashyap@linaro.org>
 <53831795.9070006@gmail.com>
 <CANuQgHH284A9QY7M5zGbSE-mXjm2KDqr54VWmtKVkbma3zZvvw@mail.gmail.com>
In-reply-to: <CANuQgHH284A9QY7M5zGbSE-mXjm2KDqr54VWmtKVkbma3zZvvw@mail.gmail.com>
Subject: RE: [PATCH v6 0/6] add cpuidle support for Exynos5420
Date: Wed, 28 May 2014 13:35:19 +0900
Message-id: <015f01cf7a2e$3b141590$b13c40b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGzWIEGzYKqrKG3HREFumhhnnpbZwJ5JUXwArMDlXoCfJWJTJtQZMMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t8zI9329NZgg9lNehYP199ksZj3WdZi
	0+NrrBaXd81hs/jce4TRYsb5fUwWb36/YLc4c/oSq8WqXX8YHTg91sxbw+ixc9Zddo871/aw
	eWxeUu+x5Wo7i8fnTXIBbFFcNimpOZllqUX6dglcGatWXWcveM9b8WhJB1MD42OuLkZODgkB
	E4lJv/ezQdhiEhfurQezhQSWMUpcbaiAqZm/9AhzFyMXUHw6o8Sj9mYWCOcvo8TpO4vBOtgE
	NCQOv3/GDmKLCERLXOqeBFbELDCVSWJv0zw2iI6fjBJPVs1kBKniFAiWODN1N1CCg0NYwE6i
	cQknSJhFQFXiwIS1TCA2r4ClxMeONcwQtqDEj8n3WEBsZgF1iUnzFjFD2NoST95dYIU4VUFi
	x9nXjBBHuEnc/PmBEaJGRGLfi3eMIDdICLRySDyd3sMMsUxA4tvkQywgN0gIyEpsOsAMMUdS
	4uCKGywTGCVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkNju
	28F484D1IcZkoPUTmaVEk/OBqSGvJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTDOPDijsCfvzpW6DWdaBdwYJOM4bOPDePwiXmUF7viQzXjc6UPM
	7M4tW/WUqjLmvErxapt9qJypfN+h4jnuRtrJQfe6xb+e/fSWQ7V61u2PqkF9Wy99bvApPPjh
	7sYTXfHiFr83qK4oCWn/ePVT7b7ZDuXVh1rsf5z+lpEhFyk1faHgl86N/feVWIozEg21mIuK
	EwHSyhdjAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHKsWRmVeSWpSXmKPExsVy+t9jQd329NZggxczNC0err/JYjHvs6zF
	psfXWC0u75rDZvG59wijxYzz+5gs3vx+wW5x5vQlVotVu/4wOnB6rJm3htFj56y77B53ru1h
	89i8pN5jy9V2Fo/Pm+QC2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgI5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWas
	WnWdveA9b8WjJR1MDYyPuboYOTkkBEwk5i89wgxhi0lcuLeerYuRi0NIYDqjxKP2ZhYI5y+j
	xOk7i9lAqtgENCQOv3/GDmKLCERLXOqeBFbELDCVSWJv0zyo9p+MEk9WzWQEqeIUCJY4M3U3
	UIKDQ1jATqJxCSdImEVAVeLAhLVMIDavgKXEx441zBC2oMSPyfdYQGxmAXWJSfMWMUPY2hJP
	3l1ghThVQWLH2deMEEe4Sdz8+YERokZEYt+Ld4wTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcOp4JrWDcWWDxSFGAQ5GJR7eA4tbgoVYE8uKK3MPMUpw
	MCuJ8P4JaA0W4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgWssriTc0NjEzsjQyszAyMTcn
	TVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYpQpEneSZM+amndiRbJpH3le3x/txNf/Uu
	J9//f/izYLt/TdKtyeGekTtmJHpcPsK+f/6Kq1fZeuw9Fzw5/0n6xMN9ZgujfJ6/Eripor1+
	X98E69thnzZV55/cEDyX/bn1i84/8UfWBHC+X+Ld//mrw8xZr2s4tm/yjZ14zcpxQdRWtZtm
	gbpmSizFGYmGWsxFxYkAIjlczGEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chander Kashyap wrote:
> 
> On 26 May 2014 15:59, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> > Hi Chander,
> >
> > On 16.05.2014 10:03, Chander Kashyap wrote:
> >> Exynos5420 is a big-little Soc from Samsung. It has 4 A15 and 4 A7
> cores.
> >>
> >> This patchset adds cpuidle support for Exynos5420 SoC based on
> >> generic big.little cpuidle driver.
> >>
> >> Tested on SMDK5420.
> >>
> >> This patch set depends on:
> >>       1. [PATCH 0/5] MCPM backend for Exynos5420
> >>          http://www.spinics.net/lists/arm-kernel/msg331100.html
> >> Changelog is in respective patches.
> >> Chander Kashyap (5):
> >>   driver: cpuidle-big-little: add of_device_id structure
> >>   arm: exynos: add generic function to calculate cpu number
> >>   cpuidle: config: Add ARCH_EXYNOS entry to select cpuidle-big-little
> >>     driver
> >>   driver: cpuidle: cpuidle-big-little: init driver for Exynos5420
> >>   exynos: cpuidle: do not allow cpuidle registration for Exynos5420
> >>   mcpm: exynos: populate suspend and powered_up callbacks
> >>
> >>  arch/arm/mach-exynos/exynos.c        |    4 +++-
> >>  arch/arm/mach-exynos/mcpm-exynos.c   |   36
> ++++++++++++++++++++++++++++++++++
> >>  arch/arm/mach-exynos/regs-pmu.h      |    9 +++++++++
> >>  drivers/cpuidle/Kconfig.arm          |    2 +-
> >>  drivers/cpuidle/cpuidle-big_little.c |   12 +++++++++++-
> >>  5 files changed, 60 insertions(+), 3 deletions(-)
> >>
> >
> > For the whole series,
> >
> > Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> 
> Thanks Tomasz.
> 
> Dear Kukjin,
> Can you take these patches.
> >
When I looked at this series quickly, looks good to me but I need to get ack from cpuidle maintainer Rafael or Daniel.

Thanks,
Kukjin

