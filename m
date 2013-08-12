Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3HLBzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:55:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27776 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3HLBzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:55:04 -0400
X-AuditID: cbfee691-b7fef6d000002d62-20-52084075e963
Date: Mon, 12 Aug 2013 10:55:01 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 14/16] iommu/exynos: add support for power management
 subsystems.
Message-id: <20130812105501.d5c52155b378b5e2f4d4bb53@samsung.com>
In-reply-to: <3833452.V3JQdooaWE@flatron>
References: <003201ce941b$6e5a90e0$4b0fb2a0$@samsung.com>
 <1949492.N82v2nAcIY@flatron>
 <20130809164943.fe4b673e92b3f7680562f29b@samsung.com>
 <3833452.V3JQdooaWE@flatron>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsVy+t8zA91SB44ggx9nzCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSxW7frD6MDv8eTgPCaP2Q0XWTx2zrrL7nHn2h42j/Ob1jB7bF5S7zH5xnJGj74t
	qxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bMqXuZClaKVPRt+c3awLiPv4uRk0NCwETi
	9bsjjBC2mMSFe+vZuhi5OIQEljFKnD91mhmm6O7ny+wQiemMElP/XoOqmsQk8W5CD1MXIwcH
	i4CqxIKTCSANbAJaEqvnHgebKiKgLvFtSj87iM0s8INF4tM2PhBbWCBKYs/+mWA1vAKOEpdv
	PmQFsTkFNCVe7ZzBDDF/PaPExHvn2SCusJC40NTBDtEgKPFj8j0WiKFaEpu3NbFC2PISm9e8
	BWuWEFjJIbH82wOwDSwCAhLfJh9iATlUQkBWYtMBqM8kJQ6uuMEygVFsFpKxs5CMnYVk7AJG
	5lWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYIXE/cQfj/QPWhxiTgVZOZJYSTc4Hpo28knhD
	YzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqVkXzWFWt
	c3kj4ftt9s21abtOrXm7c12/Sh3T3lCeNzUz31VPbJGKXN/PoSKhu8Yovb9p5+LnN1bqHl2c
	orxuYqbIVnX52wUHT++8fZBf1XmJQUbujHzGX59/nDzy9ajE9w1FXfwGm8Ouu8j+Y+C9t+GZ
	he3c/atuPqu62S7XwSMoOmmWyZ1/SizFGYmGWsxFxYkAss0fkBEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jQd1SB44gg9YjBhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TBardv1hdOD3eHJwHpPH7IaLLB47Z91l97hzbQ+bx/lNa5g9Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgCuqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGzKl7
	mQpWilT0bfnN2sC4j7+LkZNDQsBE4u7ny+wQtpjEhXvr2boYuTiEBKYzSkz9ew3KmcQk8W5C
	D1MXIwcHi4CqxIKTCSANbAJaEqvnHmcEsUUE1CW+TekHG8Qs8INF4tM2PhBbWCBKYs/+mWA1
	vAKOEpdvPmQFsTkFNCVe7ZzBDDF/PaPExHvn2SCusJC40NTBDtEgKPFj8j0WiKFaEpu3NbFC
	2PISm9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcVJ5J
	72Bc1WBxiFGAg1GJh9fjC3uQEGtiWXFl7iFGCQ5mJRHeemOOICHelMTKqtSi/Pii0pzU4kOM
	ycDQmMgsJZqcD0x4eSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAKPHs7sfrXC+9w2yLPl2weG77ccPbxVOyjTJP8X9c7LW/9rHutoktu/hLRWYHyUWl+Hec
	6NFRsg7hTbk7b8eW5N8L1dZf/9ormTP9cpdbYmj1tzcOnSuvfvVbrDphcsDK6MoDd77MipGK
	exj8fH1wX+27J/bzd0dV+PWc2rZXQ9OcVfng7zmu+5RYijMSDbWYi4oTAQ+TVUVuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 10:32:40 +0200, Tomasz Figa wrote:
> On Friday 09 of August 2013 16:49:43 Cho KyongHo wrote:
> > On Fri, 09 Aug 2013 01:03:05 +0200, Tomasz Figa wrote:
> > > Hi KyongHo,
> > > 
> > > nit: Please drop the trailing dot at the end of patch subject.
> > 
> > Oh. I didn't catch that.
> > Thank you.
> > 
> > > On Thursday 08 of August 2013 18:41:17 Cho KyongHo wrote:
> > > > This adds support for Advance Power Management and Runtime Power
> > > > Management.
> > > 
> > > This patch adds support for system-wide and runtime power management.
> > 
> > Ok.
> > 
> > > > Since System MMU is located in the same local power domain of its
> > > > master H/W, System MMU must be initialized before it is working if
> > > > its power domain was ever turned off. TLB invalidation according to
> > > > unmapping on page tables must also be performed while power domain
> > > > is
> > > > turned on.
> > > > 
> > > > This patch ensures that resume and runtime_resume(restore_state)
> > > > functions in this driver is called before the calls to resume and
> > > > runtime_resume callback functions in the drivers of master H/Ws.
> > > > Likewise, suspend and runtime_suspend(save_state) functions in this
> > > > driver is called after the calls to suspend and runtime_suspend in
> > > > the
> > > > drivers of master H/Ws.
> > > > 
> > > > In order to get benefit of this support, the master H/W and its
> > > > System
> > > > MMU must resides in the same power domain in terms of Linux kernel.
> > > > If
> > > > a master H/W does not use generic I/O power domain, its driver must
> > > > call iommu_attach_device() after its local power domain is turned
> > > > on,
> > > > iommu_detach_device before turned off.
> > > 
> > > I don't get the point of this last paragraph. What a power domain can
> > > be in other terms? Is there any other way to support power domains on
> > > Exynos than generic power domains?
> > 
> > I just addressed the case a device driver turns off local power of its
> > device without the help of generic I/O powerdomain.
> 
> Out of curiosity, do we have such cases for Exynos in mainline kernel? 
> IMHO this is what the generic PM core is for and drivers shouldn't care 
> about such low level PM details.

I don't know if there is the case and I also agree with you.

I hope that there is no case that I addressed.
I just mentioned an exceptional case.
The best way is that all device drivers of master H/W of System MMU register
their defvice in a generic i/o powerdomain.

Thank you.

KyongHo.
