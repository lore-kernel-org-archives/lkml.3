Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbaCQA0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:26:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52597 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaCQA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:26:48 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-7a-53264146dced
Date: Mon, 17 Mar 2014 09:26:46 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v11 01/27] iommu/exynos: do not include removed header
Message-id: <20140317092646.b696d2245fb95ea8835cbd2e@samsung.com>
In-reply-to: <CAK9yfHyGfdP+0RKtdSCdU4tO=PX8GbQRQ7ar=ST5B2RenZMMsg@mail.gmail.com>
References: <20140314140129.68a41cc1bd9e0a48a198ca13@samsung.com>
 <CAK9yfHzRasE3jroDUZgAa=DN5N=2ZDAxgNiHDCip+f2868BAVQ@mail.gmail.com>
 <000e01cf3f7b$6edcdfd0$4c969f70$@samsung.com>
 <CAK9yfHyGfdP+0RKtdSCdU4tO=PX8GbQRQ7ar=ST5B2RenZMMsg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zA103R7Vgg/NPzCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mp4dGE9S8Fs3oq9+xayNTAe5epi5OSQEDCR+Hb3HCOE
	LSZx4d56ti5GLg4hgWWMEp8b21lgij7+v8UEkVjEKLFv/xooZzKTxN6lfUwgVSwCqhKTf/4B
	s9kEtCRWzz0ONlYEyH7ZvRysgVngJ4vEpbfPWEESwgJeElNf3mMGsXkFHCUWHe4HszkFgiV2
	dp9nhNjwn1Fi+7EmNog7LCQuNHWwQzQISvyYfA/sPmagDZu3NbFC2PISm9e8ZQZplhCYyyFx
	6ekqFojzBCS+TT4EZHMAJWQlNh1ghpgpKXFwxQ2WCYxis5CMnYVk7CwkYxcwMq9iFE0tSC4o
	TkovMtUrTswtLs1L10vOz93ECIn4iTsY7x+wPsSYDLRyIrOUaHI+MGHklcQbGpsZWZiamBob
	mVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj+/LNZx6ENigXbOhKLZ+Z
	ukd59v+6atPdzmWvv8/YxyJxMkM8p/qWyHRBF17OJONtEtGinxkz3VQfbbeP2H064JfM1jsz
	RMs67CJiPaf/+3Mo0XmBusYUSaWad0J/k5Rmcit++xvdrnJo/e80724bK5nGZH+BVKkfnFXJ
	qyPjzj07InJKNFuJpTgj0VCLuag4EQBedw03DgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jAV03R7VggzdLDC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8ejCepaC2bwV
	e/ctZGtgPMrVxcjJISFgIvHx/y0mCFtM4sK99WxdjFwcQgKLGCX27V/DBOFMZpLYu7QPrIpF
	QFVi8s8/YDabgJbE6rnHGUFsESD7ZfdysAZmgZ8sEpfePmMFSQgLeElMfXmPGcTmFXCUWHS4
	H8zmFAiW2Nl9nhFiw39Gie3Hmtgg7rCQuNDUwQ7RICjxY/I9FhCbGWjD5m1NrBC2vMTmNW+Z
	JzAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBKeTZ1I7GFc2WBxi
	FOBgVOLhnaCsFizEmlhWXJl7iFGCg1lJhDfBHCjEm5JYWZValB9fVJqTWnyIMRkYHhOZpUST
	84GpLq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGLXqxI/5
	Se81e9JfsOTxvL0n2drMSz0CRJKEQ9bPvJS3iO1Lzrp5Ghsuibi4yDzVWFS08WNUXHX5VHFu
	93qPFU1Vs5bVhQsbSXDXdbjbyPMw8opuWntwneksfc38tdypDWfrKzJbnU5+usAorjXjWOif
	he5n5ijxXnRbFFr98aP0+47j6TfZlViKMxINtZiLihMB+QD2zGsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 17:29:36 +0530, Sachin Kamat wrote:
> On 14 March 2014 17:19, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> >> Sent: Friday, March 14, 2014 7:00 PM
> >>
> >> On 14 March 2014 10:31, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> > Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
> >> > exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
> >> > removing remaining use of it from exynos-iommu driver, thus causing a
> >> > compilation error.
> >> >
> >> > This patch fixes the error by removing respective include line
> >> > from exynos-iommu.c.
> >> >
> >> > CC: Tomasz Figa <t.figa@samsung.com>
> >> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >> > ---
> >> >  drivers/iommu/exynos-iommu.c |    3 +--
> >> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> >> > index 0740189..4876d35 100644
> >> > --- a/drivers/iommu/exynos-iommu.c
> >> > +++ b/drivers/iommu/exynos-iommu.c
> >> > @@ -12,6 +12,7 @@
> >> >  #define DEBUG
> >> >  #endif
> >> >
> >> > +#include <linux/kernel.h>
> >>
> >> This change doesn't look related to the patch subject/description.
> >>
> > Yes. But it is simply added without any side-effect.
> > Do you think it should be in a separate patch?.
> > Actually, the added line is a redundant.
> 
> If it is redundant, then you shouldn't be adding it. If it is
> required, then please
> mention about the need in the commit description if not a separate patch.
> 

Ok.

Thanks for the advice.

KyongHo
