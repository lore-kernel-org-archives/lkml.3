Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaCTL4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:56:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60457 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaCTL4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:56:05 -0400
X-AuditID: cbfee690-b7f266d00000287c-58-532ad73df9c0
Date: Thu, 20 Mar 2014 20:55:41 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Tomasz Figa <t.figa@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
Message-id: <20140320205541.d7ef53fd15d9dcd3cadfd13f@samsung.com>
In-reply-to: <CANEJEGtK-XfTef3ko+Yq2RNFXohhuQjgamr-DRBmxR-SNzgkJg@mail.gmail.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
 <5322FD14.5090602@samsung.com>
 <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
 <532861BE.7020601@samsung.com>
 <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
 <532997D7.6090608@samsung.com>
 <CANEJEGtK-XfTef3ko+Yq2RNFXohhuQjgamr-DRBmxR-SNzgkJg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zY13b61rBBov2aVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJUx79x+loK1PBWTrixnbmB8x9nFyMkhIWAisf3oISYI
	W0ziwr31bF2MXBxCAssYJXZve8kCU3TpQB8zRGI6o8TBvf+hqiYzSRya84W9i5GDg0VAVeLZ
	dzmQBjYBLYnVc48zgtgiQPaM/edYQeqZBX6zSMzc/okVJCEsEC5x6sZHsA28Ao4SE869ArM5
	BYIlzk2fAVYjJHCbSWLbcTaIKywkLjR1sEPUC0r8mHwPrJ4ZaMHmbU2sELa8xOY1b8EulRBY
	yiHRCAwIkASLgIDEt8mHWEAOlRCQldh0gBlipqTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0
	tSC5oDgpvchErzgxt7g0L10vOT93EyMk2ifsYLx3wPoQYzLQyonMUqLJ+cBkkVcSb2hsZmRh
	amJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEs1K4+u/sir+kXj
	+ZbVD6dt/sibNPHNMf4616eGkuKvnJ+uP1F18HZ+287Xd1z7p94J+GurqHlw6ZboJN/Fv1Zd
	nNJkprJv2l/HHtu6/iUv5xkFPjS1dd73K2F76ny+b+3xTHWO22wOOucdYRTRP+H3a+HsIsEd
	njkvJ17num67cUsE0+Mv6feVWIozEg21mIuKEwG/vUmtDAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQV3b61rBBi3vVCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYMe/cfpaCtTwV
	k64sZ25gfMfZxcjJISFgInHpQB8zhC0mceHeerYuRi4OIYHpjBIH9/6HciYzSRya84W9i5GD
	g0VAVeLZdzmQBjYBLYnVc48zgtgiQPaM/edYQeqZBX6zSMzc/okVJCEsEC5x6sZHFhCbV8BR
	YsK5V2A2p0CwxLnpM8BqhARuM0lsO84GcYWFxIWmDnaIekGJH5PvgdUzAy3YvK2JFcKWl9i8
	5i3zBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4FTyTHoH46oG
	i0OMAhyMSjy8K/ZoBguxJpYVV+YeYpTgYFYS4V1yWStYiDclsbIqtSg/vqg0J7X4EGMyMDQm
	MkuJJucD01xeSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAm
	yD29ds9s0s3uI10ZvFcemihLG1dpuzN5X1kr99VqHy978q2ft1K/b1i5+W1pS/pfq++H+BeI
	hf65nPIhOm+Kmc+ktA/63CU64t/Ycn7X56Yejn3nO2P75cJZXeZvZGxEI7Pz+6P2/1/x4Ijz
	zsPPog6+i8q6pLvq/VSZyzYOK3/JxIlL/T+pxFKckWioxVxUnAgA6foiUWkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 09:54:39 -0700, Grant Grundler wrote:
> On Wed, Mar 19, 2014 at 6:12 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> ...
> >> Device driver is not only for the scholarship but also for the real use.
> >
> > Huh? I'm not sure what kind of comment is this.
> 
> I'm guessing Cho meant: "This isn't an academic exercise - I have a
> real use case that requires reference counting."

That is what I meant; Sorry for my poor English :-)

> Cho needs to be more specific about his "Some driver needs enabling
> sysmmu" example. Then others would understand why/when the reference
> counting is needed. Ie walk through a real driver that exists today
> that depends on reference counting.
>

One of my recent experience is that a display controller (FIMD) driver
of a SoC manages two different context of power management:
One is turning on and off display screen (LCD) (which is as usual as previous SoCs)
and the other is gating its internal clock including System MMU very
frequently to reduce power consumption.
Because System MMU driver holds its clock ungated while it is enabled,
FIMD driver explicitely disable System MMU.

Yes, well designed FIMD driver must care about balancing of
disabling and enabling System MMU between different contexts.
But the design of some complex driver may be poor in few features due to
agressive development schedule sometimes.

Please let me think about the counting.

Now I also think the system mmu driver does not need to make
an extra effort for some special cases.

Regards,

KyongHo
