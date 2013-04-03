Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab3DCCDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:03:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53905 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3DCCDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:03:05 -0400
X-AuditID: cbfee68d-b7f786d000005188-b3-515b8dcee78f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: "'Jongpill Lee'" <boyko.lee@samsung.com>,
        "'Jaecheol Lee'" <jc.lee@samsung.com>,
        "'Thomas Abraham'" <thomas.ab@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Jonathan Kliegman'" <kliegs@chromium.org>,
        "'Michael Spang'" <spang@chromium.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
References: <1363711900-25560-1-git-send-email-dianders@chromium.org>
In-reply-to: <1363711900-25560-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 0/2] These two patches to s3c_pm_arch_prepare_irqs() were
 part of the work
Date: Wed, 03 Apr 2013 11:02:53 +0900
Message-id: <24b401ce300f$5a767b40$0f6371c0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kwh4+tmVwE2NsTjCjLWp9CdcbiQLTK8Vg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zA91zvdGBBvP3SlvsPreQzeLssoNs
	FhM/3GO0mLN8MbvFpsfXWC0u75rDZjHj/D4mi9uXeS1OXf/MZnHzYReLRccyRgduj5bmHjaP
	2Q0XWTw2L6n3uHKiidWjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4MhZt38peMIGj4lDnVJYG
	xk1sXYwcHBICJhLT+ly7GDmBTDGJC/fWA4W5OIQEljFKfNz9mREiYSKx9VgXE0RiOqPEqo3T
	oJy/jBLvpt1mA6liE9CQOPz+GTuILSKgLfHywUpmkCJmgXZmif1rnjKBJIQEXCWuH7sFtppT
	wE3i6z9BkLCwQILEnikzwHpZBFQlZt1czQpSwitgK/F0gR5ImFdAUOLH5HssIDazgJbE+p3H
	mSBseYnNa94yQzyjLvHory7EBUYSH7pmQJWISOx78Y4R5BoJgYkcEpev9LFBrBKQ+Db5EAtE
	r6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqX
	rpecn7uJERLnvTsYbx+wPsSYDLR+IrOUaHI+ME3klcQbGpsZWZiamBobmVuakSasJM6r1mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRZ2eKeq8vR5vK+3tb5vkfYewvvbzs9Cv9Q58f
	q2TNd9nnZzB/vfLfnctn71TZralzb+0tBRuL7O6HZ+SKGGUnBkzIbs7VSvLkfvi57r7mr+f7
	clbovfCV11s2/fb9NMbnYc+v/ppjdOkXF2ct44msdVaOR/LkrI02/ZnElvzP76hpvVXhFlcG
	JZbijERDLeai4kQAXZjz4AkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCKsWRmVeSWpSXmKPExsVy+t9jQd1zvdGBBtN2iFnsPreQzeLssoNs
	FhM/3GO0mLN8MbvFpsfXWC0u75rDZjHj/D4mi9uXeS1OXf/MZnHzYReLRccyRgduj5bmHjaP
	2Q0XWTw2L6n3uHKiidWjb8sqRo/Pm+QC2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTX
	Y2SABhLWMWYs2r6VvWACR8WhzqksDYyb2LoYOTkkBEwkth7rYoKwxSQu3FsPFOfiEBKYziix
	auM0JgjnL6PEu2m3wTrYBDQkDr9/xg5iiwhoS7x8sJIZpIhZoJ1ZYv+ap2CjhARcJa4fuwXU
	wMHBKeAm8fWfIEhYWCBBYs+UGWC9LAKqErNurmYFKeEVsJV4ukAPJMwrICjxY/I9FhCbWUBL
	Yv3O40wQtrzE5jVvmUHKJQTUJR791YW4wEjiQ9cMqBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJ
	ywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWnkmdQOxpUNFocYBTgYlXh4T3yJChRi
	TSwrrsw9xCjBwawkwns6LDpQiDclsbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBKS6vJN7Q2MTM
	yNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhhXcH0+MPFkpte/l98vq1z5
	s3m7o1DFt7s+0V5mYRXf83d+nifJYvdaxfK1lpBUqMaeG9wlabpzGtqjfosmfy7f/simT0uh
	du7pEkMv5aBLnJf5lD36utJer2yQOaocWWr4n2/93wsPNsxhbb3RdCO4J5ljrVZagxH7jvLK
	JBUr4X/WG48fllFiKc5INNRiLipOBABNoQ1DZwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> to make suspend/resume reliable on the ARM Chromebook
> (exynos5250-snow).
> 
> A few more details:
> - The first patch is not strictly needed but was a nice cleanup.  Our
>   understanding was that EINT0 was originally turned on for exynos
>   evt0 silicon and not needed for evt1.

Looks good to me, applied, thanks.

> - The second patch is more important and (also) more obvious.  The
>   function was modifying the S5P_WAKEUP_MASK register and then
>   clobbering its own modifications.
> 
Applied with 1st one, BTW, do you want to send this for stable tree?

- Kukjin

> For some history, see:
> - https://gerrit.chromium.org/gerrit/31337
> - https://gerrit.chromium.org/gerrit/31341
> 
> 
> Jonathan Kliegman (2):
>   arm: exynos: Remove hardcode wakeup unmask for EINT_0
>   arm: exynos: Clear ENABLE_WAKEUP_SW bit when entering suspend
> 
>  arch/arm/mach-exynos/include/mach/pm-core.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> --
> 1.8.1.3

