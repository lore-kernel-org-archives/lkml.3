Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab3HIBAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:00:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54554 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab3HIBAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:00:19 -0400
X-AuditID: cbfee68e-b7f276d000002279-6e-52043f21c0f5
Date: Fri, 09 Aug 2013 10:00:16 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
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
Subject: Re: [PATCH v9 00/16] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-id: <20130809100016.a22e5938a829f229eb5df00f@samsung.com>
In-reply-to: <2763595.7SYUCgBHXZ@amdc1227>
References: <002401ce941a$dad907c0$908b1740$@samsung.com>
 <2763595.7SYUCgBHXZ@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zfV1Fe5Ygg+atPBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls/h46ji7xabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4uSf
	XkaLluu9TBbrZ7xmceD3eHJwHpPH7IaLLB53ru1h8zi/aQ2zx+Yl9R6Tbyxn9OjbsorR4/Mm
	OY8rR88wBXBGcdmkpOZklqUW6dslcGU8m3GbreC7WcWkBfuYGxjXa3UxcnJICJhI/F/7lBnC
	FpO4cG89G4gtJLCMUWL3OkOYmutv7wHFuYDiixglFm08AeVMYpL4fn8pE0gVi4CqxKmj51hB
	bDYBLYnVc48zgtgiAioSl09NB7OZBX6wSHzaxgdiCwskSpyYcAlsG6+Ao8TUDddZQGxOoN5p
	u9czQ1wRKTHx7UFGiCssJC40dbBD1AtK/Jh8jwVippbE5m1NrBC2vMTmNW+ZQY6TEFjIIbH6
	QC8zxHECEt8mHwJq4ABKyEpsOgD1saTEwRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0tSC5oDgp
	vchIrzgxt7g0L10vOT93EyMk1vt2MN48YH2IMRlo5URmKdHkfGCqyCuJNzQ2M7IwNTE1NjK3
	NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QD45KnIS4nH2y9Y+p+8EG9t8LG
	xzee7jiu43rpfESi1L/Ua0c07pYdk/HpdPiQn97/r3hKotSpt4cXbql+dJfrp5DMxycbru2b
	d6SHP9XoUrl5J1ft1ARdqWMsrG88PBeVzMyzObzp3o4WrZ1sNRyd7nPS7gqsF7l0rHNmoyJf
	4LXAtQeUN0/XOq7EUpyRaKjFXFScCAAD7BKICwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jAV1Fe5Ygg60fWS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jN4sDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WzGbbaC72YV
	kxbsY25gXK/VxcjJISFgInH97T02CFtM4sK99UA2F4eQwCJGiUUbT0A5k5gkvt9fygRSxSKg
	KnHq6DlWEJtNQEti9dzjjCC2iICKxOVT08FsZoEfLBKftvGB2MICiRInJlwC28Ar4CgxdcN1
	FhCbE6h32u71zCC2kECkxMS3BxkhrrCQuNDUwQ5RLyjxY/I9FoiZWhKbtzWxQtjyEpvXvGWe
	wCgwC0nZLCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnEqeSe9gXNVgcYhR
	gINRiYdXcTtzkBBrYllxZe4hRgkOZiUR3hdZQCHelMTKqtSi/Pii0pzU4kOMycDQmMgsJZqc
	D0xzeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAOOvndg2b
	2SmO8p+WqC4p8llc8ZPTY0vZqcN+747//q//Va+C1/Cw8SvBe/vWr2G7WOB+SHBvYLoZx6Ps
	j8c95n/433HwW+3Vif9WsXswSh/W/XrUoc1A4QuX0fZbLM7ue6/acIvc/WzTvm7nxKa/DSxx
	B1QUjlvX9R8/OE1tr/ad1Rc3H/ii2abEUpyRaKjFXFScCADRVuJmaQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 14:13:57 +0200, Tomasz Figa wrote:

> Hi KyongHo,
> 
> Just a little hint for future:
> 
> To make reviewing your patches easier, please send all patches (01 and 
> further) as a follow up (reply) to cover letter of the series (patch 00).
> 
> This can be achieved by using --thread switch of git send-email for 
> example.
> 

Thank you for advice.
However, git send-email and something like that is prohibitted by the
security policy of my company :(
I used an email client in windows O/S.

I need more consideration to the patches are sent in the order of patches.

Thank you.

KyongHo.

> Best regards,
> Tomasz
> 
> On Thursday 08 of August 2013 18:37:10 Cho KyongHo wrote:
> > The current exynos-iommu(System MMU) driver does not work autonomously
> > since it is lack of support for power management of peripheral blocks.
> > For example, MFC device driver must ensure that its System MMU is
> > disabled before MFC block is power-down not to invalidate IOTLB in the
> > System MMU when I/O memory mapping is changed. Because a System MMU
> > resides in the same H/W block, access to control registers of System MMU
> > while the H/W block is turned off must be prohibited.
> > 
> > This set of changes solves the above problem with setting each System
> > MMUs as the parent of the device which owns the System MMU to receive
> > the information when the device is turned off or turned on.
> > 
> > Another big change to the driver is the support for devicetree.
> > The bindings for System MMU is described in
> > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
> > 
> > In addition, this patchset also includes several bug fixes and
> > enhancements of the current driver.
> > 
> > Change log:
> > v9:
> > - Rebased on the following branches
> >   git.linaro.org/git-ro/people/mturquette/linux.git/clk-next
> >  
> > git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git/samsung-
> > next git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/master
> > (3.11-rc4) - Split "add bus notifier for registering System MMU" into 5
> > patches - Call clk_prepare() that was missing in v8.
> > - Fixed base address of sysmmu_tv in exynos4210.dtsi
> > - BUG_ON() instead of return -EADDRINUSE when trying mapping on an mapped
> > area - Moved camif_top to 317 in drivers/clk/samsung/clk-exynos5250.c -
> > Removed 'iommu' property from 'codec'(mfc) node
> > - Does not make 'master' clock to be the parent of 'sysmmu' clock.
> >    'master' clock is enabled before accessing control registers of System
> > MMU and disabled after the access.
> > 
> > v8:
> > - Reordered patch list: moved "change rwloc to spinlock" to the last.
> > - Fixed remained bug in "fix page table maintenance".
> > - Always return 0 from exynos_iommu_attach_device().
> > - Removed prefetch buffer setting when System MMU is enabled
> >   due to the restriction of prefetch buffers:
> >   A prefetch buffer must not hit from more than one DMA.
> >   For instance with GScalers, if a single prefetch buffer is initialized
> >   with 0x0 ~ 0xFFFFFFFF and a GScaler works on source buffer at
> > 0x10000000 and target buffer @ 0x20000000, the System MMU may be got
> > deadlock. Clients must initialize prefetch buffers with custom function
> > defined in exynos-iommu drivers whenever they need to enable prefetch
> > buffers. - The clock of System MMU has no relationship with the clock of
> > its master H/W. The clock of master H/W is always enabled when
> > exynos-iommu driver needs to access MMIO area and disabled as soon as
> > the access finishes. - Removed err_page variable used in
> > exynos_iommu_unmap() in the previous patch "fix page table maintenance".
> > - Split a big patch "add bus notifier for registering System MMU".
> >    Extracted the following 2 patches: 9/12 and 10/12.
> > - And some additional fixes...
> > 
> > v7:
> > - Rebased on the stable 3.10
> > - Registered PM domains and gate clocks with DT
> > - Changed connection method between a System MMU and its master H/W
> >    'mmu-master' property in the node of System MMU
> >    --> 'iommu' property in the node of master H/W
> > - Marking device descriptor of master H/W of a System MMU with bus
> > notifier. - Power management (PM_RUNTIME, PM_SLEEP) of System MMUs with
> > gpd_dev_ops of Generic IO Powerdomain. gpd_dev_ops are set to the master
> > H/Ws before they are probed in the bus notifier.
> > - Removed additional debugging features like debugfs entries and
> >    version names.
> > - Removed support for advanced features of System MMU 3.2 and 3.3
> >    the current IOMMU API cannot handle the feature
> >   (A kind of L2 TLB that fetches several consequence page table entries.
> >    It must be initialized by the driver of master H/W whenever it works.)
> > 
> > v6:
> > - Rebased on the branch, next/iommu-exynos of
> >   git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
> > 
> > v5:
> > - new bugfix: patch 01
> > - Reordered patches
> >   * patch 01 ~ 05: Bugfix and enhancements of the existing driver
> >   * patch 06 ~ 10: Device Tree support and callbacks for power management
> > * patch 11     : System MMU 3.2 and 3.3 support
> >   * patch 12 ~ 14: Debugging features
> > - Additional code compaction
> > 
> > v4:
> > - Remove Change-Id from v3 patches
> > - Change the order of the third and the first patch
> >   Thanks to Kukjin Kim.
> > - Fix memory leak when allocating and assigning exynos_iommu_owner to
> > client device if the client device has multiple System MMUs.
> >   Thanks to Rahul Sharma.
> > 
> > v3:
> > - Fix prefetch buffer flag definition for System MMU 3.3 (patch 10/12)
> > - Fix incorrect setting for SET_RUNTIME_PM_OPS (patch 09/12)
> >   Thanks to Prathyush.
> > 
> > v2:
> > - Split the patch to iommu/exynos into 9 patches
> > - Support for System MMU 3.3
> > - Some code compaction
> > 
> > Patch summary:
> > 
> > Diffstats:
> >  .../devicetree/bindings/clock/exynos5250-clock.txt |   26 +
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 ++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  122 +++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 +
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  290 ++++++
> >  drivers/clk/samsung/clk-exynos4.c                  |   27 +-
> >  drivers/clk/samsung/clk-exynos5250.c               |   57 +-
> >  drivers/iommu/Kconfig                              |    5 +-
> >  drivers/iommu/exynos-iommu.c                       | 1061
> > +++++++++++++------- 10 files changed, 1423 insertions(+), 375
> > deletions(-)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-samsung-soc" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
