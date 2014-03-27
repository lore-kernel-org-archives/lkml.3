Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaC0KIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:08:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31545 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaC0KIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:08:11 -0400
X-AuditID: cbfee68e-b7f566d000002344-02-5333f88a4815
Date: Thu, 27 Mar 2014 10:08:10 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 0/4] devfreq: exynos: generalize PPMU code
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140327100804850@myungjoo.ham
Msgkey: 20140327100804850@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140327100804850@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14716616.146541395914888684.JavaMail.weblogic@epml10>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42JZI2JSotv1wzjY4NVWWYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVxcNYf9oIVEhW77z1hbWC8It7FyMkhJKAusWjJSTYQW0LAROLu
	uq0sELaYxIV764HiXEA1SxklmjrXsMMUXX91iBEiMZ9R4tbmC2AdLAKqEi82bAeyOTjYBMwl
	7s8IAgkLC9hJzF47lxnEFhEol1j+/i8rSC+zwEsmib/HLjJBXKEksWbfK7A5vAKCEidnPoG6
	QlXi7O1Z7BBxNYnti74zQ8QlJGZNv8AKYfNKzGh/ClUvJzHt6xqoGmmJ87M2MMJ8s/j7Y6g4
	v8Sx2zuYQO4E6X1yPxhmzO7NX6ABISAx9cxBqFYticMbz0KN55NYs/AtC8yYXaeWM8P03t8y
	F+wVZgFFiSndD9khbC2JLz/2saF7i1fASeLB6bXsExiVZyFJzULSPgtJO7KaBYwsqxhFUwuS
	C4qT0ouM9IoTc4tL89L1kvNzNzECE8Ppf8/6djDePGB9iDEZGCUTmaVEk/OBiSWvJN7Q2MzI
	wtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB27PZp5HE1CX/Q
	0+/0PvDNQ0vByuzHD/2OsxyZoRW+7oAT32Tn+a++XihkOvU4/ekvsX8pO89NuhPctMJ/h8vP
	d/aOC9Z+n3lKZ2dT8wn9fjWeA4WCtnEbDb9ryp7R5f+k5vRo/Yqfm25+utF0aWforhPbl3qn
	J6kWKisKLuhZyL1ogd7GQhsmJZbijERDLeai4kQA9AojsSIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TN2uH8bBBtu2iVlc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIyD
	s/6wF6yQqNh97wlrA+MV8S5GTg4hAXWJRUtOsoHYEgImEtdfHWKEsMUkLtxbDxTnAqqZzyhx
	a/MFFpAEi4CqxIsN24FsDg42AXOJ+zOCQMLCAnYSs9fOZQaxRQTKJZa//8sK0sss8JJJ4u+x
	i0wQy5Qk1ux7BTaHV0BQ4uTMJywQy1Qlzt6exQ4RV5PYvug7M0RcQmLW9AusEDavxIz2p1D1
	chLTvq6BqpGWOD9rA9zRi78/horzSxy7vYMJ5E6Q3if3g2HG7N78BepfAYmpZw5CtWpJHN54
	Fmo8n8SahW9ZYMbsOrWcGab3/pa5YK8wCyhKTOl+yA5ha0l8+bGPDd1bvAJOEg9Or2WfwCg3
	C0lqFpL2WUjakdUsYGRZxSiaWpBcUJyUXmGsV5yYW1yal66XnJ+7iRGcnp4t3sH4/7z1IUYB
	DkYlHt4d942ChVgTy4orcw8xSnAwK4nwnvlmHCzEm5JYWZValB9fVJqTWnyIMRkYgROZpUST
	84GpM68k3tDY2MTMxNTSxMLA1Jw0YSVx3vhbSUFCAumJJanZqakFqUUwW5g4OKUaGOMVbHe+
	0Njy5GZUhsdl9qSDezMm9D4s7lxzbsIzYcG3705+iTnv+VftN8O5o86rSzRSnvJz3r6Y+CGs
	N/PlCmmfPk5P1p+fv/H1GpddMb589ECpwS1peVOm4q9fv6kfFz7lXqBSsLvziv5/A8UnH/J3
	ZHPps68W4vPXuap82l56w3XdL3YrGpVYijMSDbWYi4oTAZCy//iTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2RA8Q3o004981



On Sat, Mar 22, 2014 at 2:31 AM, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> Hi,
>
> This patch series generalizes PPMU support for Exynos devfreq
> drivers.
>
> It is based on top of "devfreq: exynos: Fix minor issue and code
> clean to remove legacy method" patch series from Chanwoo Choi
> (https://lkml.org/lkml/2014/3/19/713).
>
> Please note that the patches were only compile tested because
> Exynos devfreq drivers don't work yet in the upstream kernels
> (FWIW these changes were briefly tested with the internal tree
> which has working devfreq drivers).

Hi Blartlomiej,


Thank you.

I'll merge this into devfreq's for-next.


Anyway, days ago, I had a short discussion with Chanwoo about
providing some common interface for PPMU-like devices
(sort of sub device of devfreq device) that provide usage statistics. 

At this stage, I roughly guess that such a device driver (or whatever
entity it is) may be simply a helper for filling out the "get_dev_status" callback.
It is because devfreq's PPMU usage is limited to getting get_dev_status().
As you had done something on PPMU, I guess you may have some
idea on this.

Cheers,
MyungJoo.
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
>
> Bartlomiej Zolnierkiewicz (3):
>   devfreq: exynos4: introduce struct busfreq_ppmu_data
>   devfreq: exynos5: introduce struct busfreq_ppmu_data
>   devfreq: exynos: make more PPMU code common
>
> Chanwoo Choi (1):
>   devfreq: exynos4: use common PPMU code
>
>  drivers/devfreq/exynos/Makefile      |   2 +-
>  drivers/devfreq/exynos/exynos4_bus.c | 176 +++++++++--------------------------
>  drivers/devfreq/exynos/exynos5_bus.c |  94 +++++--------------
>  drivers/devfreq/exynos/exynos_ppmu.c |  60 ++++++++++++
>  drivers/devfreq/exynos/exynos_ppmu.h |   8 ++
>  5 files changed, 135 insertions(+), 205 deletions(-)
>
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
 ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
