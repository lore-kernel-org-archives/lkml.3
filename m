Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3KAMhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:37:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49882 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3KAMhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:37:47 -0400
X-AuditID: cbfee690-b7f3d6d000001c4a-5d-5273a0990a0c
Date: Fri, 01 Nov 2013 21:37:45 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v10 00/20] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-id: <20131101213745.68172e8d47182cc64a591775@samsung.com>
In-reply-to: <20131101114224.GG17455@8bytes.org>
References: <20131007105212.1c2a9e29166ff4b4a33468f8@samsung.com>
 <20131101114224.GG17455@8bytes.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zfd2ZC4qDDHqOWVrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOKyyYlNSezLLVI3y6BK+Nm72y2ggViFZMnmjUw/hboYuTkkBAwkWg+
	tZcJwhaTuHBvPRuILSSwjFFi6zw1mJqVX1tZuhi5gOKLGCU2LJ3ABuFMYpL43HiMEaSKRUBV
	ovnPK1YQm01AS2L13ONgcREBJYnrn1tZQRqYBdazSnxf+ZMdJCEskCTx/8VuZhCbV8BRorH/
	HFgDp4CBRPuqycwQZ6RLHFrxkRHiDAuJC00d7BD1ghI/Jt9jAbGZgZZt3tbECmHLS2xe85YZ
	ZJmEwEoOiTNv17BDXCcg8W3yIaAGDqCErMSmA8wQMyUlDq64wTKBUWwWkrGzkIydhWTsAkbm
	VYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghUT9hB+O9A9aHGJOBVk5klhJNzgcmjbySeENj
	MyMLUxNTYyNzSzPShJXEedUeJQUBwyKxJDU7NbUgtSi+qDQntfgQIxMHp1QDo8AqRi8da6v1
	vFwxn3izeSqsVszxfn4vU7Hhb5xM+pI5hTa3H5s4yTk1NCx2Nlr9WmF/+LQ1ngqb3qfydCQn
	T1lW7Xhwkui8mK/vPyTJvk5stk48sME8y+ek+t7TBh79i/obc2e6u1zpOHnYOW3OrMKO/Lq9
	YS16NyJ/vK6czP27xeNGfP51JZbijERDLeai4kQA2W9wtxADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNKsWRmVeSWpSXmKPExsVy+t9jAd2ZC4qDDDZ2G1vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGzd7Z
	bAULxComTzRrYPwt0MXIySEhYCKx8msrC4QtJnHh3nq2LkYuDiGBRYwSG5ZOgHImMUl8bjzG
	CFLFIqAq0fznFSuIzSagJbF67nGwuIiAksT1z62sIA3MAutZJb6v/MkOkhAWSJL4/2I3M4jN
	K+Ao0dh/DqyBU8BAon3VZLC4kEC6xKEVHxkhzrCQuNDUwQ5RLyjxY/I9sPOYgZZt3tbECmHL
	S2xe85Z5AqPALCRls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFJ5Jr2D
	cVWDxSFGAQ5GJR5eh4lFQUKsiWXFlbmHGCU4mJVEeHcoFQcJ8aYkVlalFuXHF5XmpBYfYkwG
	BsdEZinR5HxgwssriTc0NjEzsjQyszAyMTcnTVhJnPdgq3UgMCQSS1KzU1MLUotgtjBxcEo1
	MGoIHpLt+Tnp4j7LRwE1U59PruW0PaxSd2i9apz2nVTZrIkHPaY37pdvdm3rsbv87JVvjy3j
	t6MfOFn5J7/l+DP1NOuxdqOQa5aT/ST/+x/O07tepiV97POUJn7umVLqXvUy25JNLt+aVsu7
	ZdKnK7P47M9uWnWvxrdZ5sjvnRL8HrNv7llXf1uJpTgj0VCLuag4EQDvsR39bgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Nov 2013 12:42:24 +0100, Joerg Roedel wrote:
> On Mon, Oct 07, 2013 at 10:52:12AM +0900, Cho KyongHo wrote:
> > Patch summary:
> > [PATCH 01/20] iommu/exynos: do not include removed header
> > [PATCH 02/20] iommu/exynos: add missing cache flush for removed page table entries
> > [PATCH 03/20] iommu/exynos: change error handling when page table update is failed
> > [PATCH 04/20] iommu/exynos: fix L2TLB invalidation
> > [PATCH 05/20] iommu/exynos: allocate lv2 page table from own slab
> > [PATCH 06/20] iommu/exynos: always enable runtime PM
> > [PATCH 07/20] iommu/exynos: always use a single clock descriptor
> > [PATCH 08/20] iommu/exynos: remove dbgname from drvdata of a System MMU
> > [PATCH 09/20] iommu/exynos: use managed device helper functions
> > [PATCH 10/20] clk: exynos: add gate clock descriptions of System MMU
> > [PATCH 11/20] ARM: dts: Add description of System MMU of Exynos SoCs
> > [PATCH 12/20] iommu/exynos: support for device tree
> > [PATCH 13/20] iommu/exynos: gating clocks of master H/W
> > [PATCH 14/20] iommu/exynos: remove custom fault handler
> > [PATCH 15/20] iommu/exynos: remove calls to Runtime PM API functions
> > [PATCH 16/20] iommu/exynos: turn on useful configuration options
> > [PATCH 17/20] iommu/exynos: add support for power management subsystems.
> > [PATCH 18/20] iommu/exynos: change rwlock to spinlock
> > [PATCH 19/20] iommu/exynos: return 0 if iommu_attach_device() successes
> > [PATCH 20/20] iommu/exynos: add devices attached to the System MMU to an IOMMU group
> > 
> > Diffstats:
> >  .../devicetree/bindings/clock/exynos5250-clock.txt |   28 +
> >  .../devicetree/bindings/clock/exynos5420-clock.txt |    3 +
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   76 ++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  105 ++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   21 +
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  262 +++++
> >  arch/arm/boot/dts/exynos5420.dtsi                  |  296 ++++++
> >  drivers/clk/samsung/clk-exynos5250.c               |   49 +-
> >  drivers/clk/samsung/clk-exynos5420.c               |   12 +-
> >  drivers/iommu/Kconfig                              |    5 +-
> >  drivers/iommu/exynos-iommu.c                       | 1033 +++++++++++++-------
> >  12 files changed, 1585 insertions(+), 387 deletions(-)
> 
> What is the state of this series? It would be good to have some
> Acked-bys and/or Reviewed-bys on it.
> 

I am preparing next patches to apply Alex Williamson's comment that
description of IOMMU's masters must be aligned with ARM SMMU.

It is delayed due to my jobs in the office.

I will post the next patche series in two weeks.

Thanks.

> 
> 	Joerg
> 
> 
