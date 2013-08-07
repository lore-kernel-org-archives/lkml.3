Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab3HGMHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 08:07:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56983 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab3HGMHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 08:07:03 -0400
X-AuditID: cbfee691-b7fef6d000002d62-44-520238654d44
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Cc: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <27536111.odlCO093Zi@amdc1032> <003c01ce91cd$427fad70$c77f0850$@samsung.com>
 <1429191.3FDem6vW0S@amdc1032> <002001ce928a$f5a7f390$e0f7dab0$@samsung.com>
 <5200F781.9020300@samsung.com>
 <CANEJEGtQuKG5err-R7SxD6m+aJWVmn47X9NJLx7UzaRkKhUMoQ@mail.gmail.com>
In-reply-to: <CANEJEGtQuKG5err-R7SxD6m+aJWVmn47X9NJLx7UzaRkKhUMoQ@mail.gmail.com>
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Wed, 07 Aug 2013 21:07:01 +0900
Message-id: <001b01ce9366$9f7427a0$de5c76e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gK7Hr4aAXxZKSACSySRwwGGYx0KAmwki5cDEVjaZpfBg0ew
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t8zY91UC6Ygg6kXVS3u3D3HarFxxnpW
	i1dHfjBZLNhvbdE5ewO7xeaD61gsehdcZbNovDeBzeLjqePsFpseX2O1uLxrDpvFjPP7mCzW
	HrnLbnFhxUZ2iymLDrNanPzTy2jRcr2XyUHQ48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtM
	vrGc0aNvyypGj8+b5DyuHD3DFMAZxWWTkpqTWZZapG+XwJWx7t8utoJOoYrTN0+yNjDO5eti
	5OSQEDCRmPboPwuELSZx4d56ti5GLg4hgWWMEmu+nmaCKfp9+gETRGIRo8S+N6ehnL+MEjs3
	/2EDqWIT0JJYPfc4I4gtIhArsX3eAbAiZoEjrBL75r2E6tjHJDFlxk6wuZwCwRJnX18F6xYW
	CJPYe2M9mM0ioCrR+GsHWA2vgKXEjmttzBC2oMSPyffAjmUWUJeYNG8RM4QtL7F5zVtmiFsV
	JHacfQ11RYzEui1ToepFJPa9eMcIcoSEwBkOiZefNzJBLBOQ+Db5EFARB1BCVmLTAag5khIH
	V9xgmcAoMQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoQkk4k7
	GO8fsD7EmAy0fiKzlGhyPjAZ5ZXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBkfniTmELE5Ennly521jOXV7zIC/9e2tjwO0Fp0TlF/MsZ+vz+3ij
	4kbAxbkLFpW0X/io+vJPS4SdXu2JdTf77+oqTryy2/ftlY3BgWdvWXCnKNwu+Sam18hpWWDL
	1vZ42teZL8KDY/IzvN/Mb68/P1XP/0fYk6cXjl54zjQlXZ3x354dK5YeZVZiKc5INNRiLipO
	BAAQS/8OPAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42I5/e+xgG6qBVOQQcceeYs7d8+xWmycsZ7V
	4tWRH0wWC/ZbW3TO3sBusfngOhaL3gVX2Swa701gs/h46ji7xabH11gtLu+aw2Yx4/w+Jou1
	R+6yW1xYsZHdYsqiw6wWJ//0Mlq0XO9lchD0eHJwHpPH7IaLLB53ru1h8zi/aQ2zx+Yl9R6T
	byxn9OjbsorR4/MmOY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
	mCsp5CXmptoqufgE6Lpl5gD9oqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0k
	rGPMWPdvF1tBp1DF6ZsnWRsY5/J1MXJySAiYSPw+/YAJwhaTuHBvPVsXIxeHkMAiRol9b04z
	QTh/GSV2bv7DBlLFJqAlsXrucUYQW0QgVmL7vANgRcwCR1gl9s17CdWxj0liyoydYHM5BYIl
	zr6+CtYtLBAmsffGejCbRUBVovHXDrAaXgFLiR3X2pghbEGJH5PvsYDYzALqEpPmLWKGsOUl
	Nq95ywxxq4LEjrOvoa6IkVi3ZSpUvYjEvhfvGCcwCs1CMmoWklGzkIyahaRlASPLKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYzgVPVMegfjqgaLQ4wCHIxKPLwVYoxBQqyJZcWVuYcYJTiY
	lUR4c42ZgoR4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5hG80riDY1NzIwsjcwsjEzMzUkT
	VhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0V3iyJN7cTwaTCqL7af93f7Lvd7oYu+0J79m
	Sr7cs962wi0idV7IIjXNC781eov7AoPVH51I+jp9UlrmTUOVDosCm/b9LTazkhT5LXStFKb/
	ufmhf+2GlROP7Fr67kxO8Nwi42MPQt9s5nZYfoufZ8XR788OBKtse8NfZs/W9Dj8yapLHU47
	GpRYijMSDbWYi4oTARwyWBqZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Wednesday, August 07, 2013 1:07 AM
> To: Marek Szyprowski
> 
> Hi Marek,
> 
> On Tue, Aug 6, 2013 at 6:17 AM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> ...
> > IMHO it is much better to have a simple driver, which binds to a single
> > IOMMU controller and leave it to the driver whether to have a same virtual address
> > space for all parts of FIMC-IS or MFC submodules/memory ports or not.
> 
> I understand this part. I having written the IOMMU support for 4
> different IOMMUs, all of which had exactly one IO Page Table and one
> IOMMU shared by many devices.
> 
> > Just make sure that it will be possible to attach more than one sysmmu
> > controller to one iommu domain.
> 
> I don't understand how this is possible. Can someone explain this
> better in the IOMMU documentation please?

System MMU is dedicated to a master H/W such as FIMD and FIMC.
Thus, attaching a master H/W to an iommu domain can be thought as
attaching a System MMU to an iommu domain even though such thinking
is not correct view of the relationship between iommu domain and
System MMU.

> 
> "iommu domain" to me means one virtual IO address space for attached
> devices that can master DMA transactions. The IOMMU then uses it's IO
> Page Table to translate the DMA address to the system physical address
> space and forwards the transaction.
> 
> What is the role of the sysmmu in all of this?
> Is the sysmmu just the MMU (or collection of MMU) for host DRAM?
> Or is sysmmu responsible for "other stuff"? (clocks, power domains, MMU, etc)
> 
System MMU is responsible for address translation of traffic from a
master H/W which the System MMU is dedicated to.

> I can understand we might have multiple MMUs in a system...e.g. every
> range of memory might have it's own MMU. But they share the same
> physical address space and generally live under one page table.
> Because of "one page table" I would consider them one entity from the
> the IOMMUs perspective.

Sorry, I don't understand.
Do you mean you are thinking that it is better to share one page table
by all IOMMUs in a system?

Thank you,
KyongHo
> 
> thanks,
> grant

