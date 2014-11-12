Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaKLMLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:11:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:64557 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaKLML3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:11:29 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-ee-54634e6fd800
Message-id: <54634E6F.6050303@samsung.com>
Date: Wed, 12 Nov 2014 21:11:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, geunsik.lim@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: pl330: Fix bug to allocate resources on ARM 64bit SoC
References: <1415790133-4206-1-git-send-email-cw00.choi@samsung.com>
 <20141112113010.GL24582@intel.com>
In-reply-to: <20141112113010.GL24582@intel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkRDffLznEYOYEaYvL+7Utpk+9wGix
	eupfVos/E1rZLCbdn8BicXnXHDaLl337WRzYPRbvecnk0bdlFaPH501yAcxRXDYpqTmZZalF
	+nYJXBnLnp1iL5ghWrFo0yK2BsZewS5GTg4JAROJ7ns/mCBsMYkL99azdTFycQgJLGWUmP93
	OhNM0bKHm1ghEosYJR7/v88C4bxmlNj/bgcLSBWvgJbE96cT2EFsFgFViX3HzrCB2GxA8f0v
	boDZogJhEiunX4GqF5T4MfkemC0CVL/lZwcjyFBmgcWMErNeTwNrEBbwl1iy+h4jiC0kkCmx
	/EMT2AJOAX2Je6ubwGqYBXQk9rdOg7LlJTavecsMMkhCYBe7xKMbi5kgLhKQ+Db5ENA2DqCE
	rMSmA8wQr0lKHFxxg2UCo9gsJDfNQjJ2FpKxCxiZVzGKphYkFxQnpReZ6BUn5haX5qXrJefn
	bmIERtnpf88m7GC8d8D6EKMAB6MSD2/CmqQQIdbEsuLK3EOMpkBXTGSWEk3OB8ZyXkm8obGZ
	kYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGPXMRTjLZ9++8/XX
	3OQTNQ6ajbrRiySSpj2afOjHnfUm0w1nhCmdvLSveqNP/DfhM83TpzFvSdDmnKQ/Oz0mkKvg
	QtD9N0VKtpW15UKZ9/if3baYNtNzseRnkxeZN/7Z1ouk2uedXlH48PjZ+G+urLvi9i9NrvwT
	zrhL/WT2YeuLrw+5mn54eFWJpTgj0VCLuag4EQBgqvTirQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jAd18v+QQg++LhSwu79e2mD71AqPF
	6ql/WS3+TGhls5h0fwKLxeVdc9gsXvbtZ3Fg91i85yWTR9+WVYwenzfJBTBHNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmLHt2ir1ghmjFok2L2BoYewW7GDk5JARMJJY9
	3MQKYYtJXLi3nq2LkYtDSGARo8Tj//dZIJzXjBL73+1gAaniFdCS+P50AjuIzSKgKrHv2Bk2
	EJsNKL7/xQ0wW1QgTGLl9CtQ9YISPybfA7NFgOq3/OxgBBnKLLCYUWLW62lgDcIC/hJLVt9j
	BLGFBDIlln9oAlvAKaAvcW91E1gNs4COxP7WaVC2vMTmNW+ZJzAKzEKyYxaSsllIyhYwMq9i
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7hZ1I7GFc2WBxiFOBgVOLh5XRIDhFiTSwrrsw9
	xCjBwawkwnvdFSjEm5JYWZValB9fVJqTWnyI0RQYBBOZpUST84HpJa8k3tDYxMzI0sjc0MLI
	2FxJnPdAq3WgkEB6YklqdmpqQWoRTB8TB6dUAyP/41ZJi0WmHvd1Xs60KldccVuN6Q3r5v18
	83eYC5Xv0HoxQ8FYeV5T0v4MJcvdt6VDnCo6shwqGCZlCC15EX00r3SlUM6BxVMreM59tTl7
	SKn+zq1nz/iPdezqOL0pMPtU15sN9w5MXzirWG/l7swph96mnVmXzR8zK/HfpT264k/OlL0q
	kPiqxFKckWioxVxUnAgAoGy9u/cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,

On 11/12/2014 08:30 PM, Vinod Koul wrote:
> On Wed, Nov 12, 2014 at 08:02:13PM +0900, Chanwoo Choi wrote:
>> This patch fix following bug to allocate resources on ARM 64bit SoC.
>> The patch[1] adds to check wheter dev is NULL or not.
> 
> Fixed already by below in my tree

Thanks for reply.
Chanwoo Choi

> 
> commit 1d7e691f1b1793f8a9439b2e8eae069e5996a187
> Author: Andrew Jackson <Andrew.Jackson@arm.com>
> Date:   Thu Nov 6 11:39:47 2014 +0000
> 
>     dmaengine: pl330: Correct device assignment.
> 
>     Commit f6f2421c0a1c removed pl330_info structure by embedding it into
>     pl330_dmac structure, but did not ensure that the dmac->ddma.dev
>     pointer gets initialised before use. When dma_alloc_coherent() gets
>     called on arm64 a WARN() gets triggered due to dev being NULL.
> 
>     ------------[ cut here ]------------
>     WARNING: CPU: 1 PID: 1 at arch/arm64/mm/dma-mapping.c:49
> __dma_alloc_coherent+0xd0/0xe0()
>     Use an actual device structure for DMA allocation
>     Modules linked in:
>     CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.17.0+ #5
>     Call trace:
>     [<ffffffc000087f24>] dump_backtrace+0x0/0x130
>     [<ffffffc000088064>] show_stack+0x10/0x1c
>     [<ffffffc0004e8af8>] dump_stack+0x74/0xb8
>     [<ffffffc0000aa444>] warn_slowpath_common+0x8c/0xb4
>     [<ffffffc0000aa4b8>] warn_slowpath_fmt+0x4c/0x58
>     [<ffffffc000092580>] __dma_alloc_coherent+0xcc/0xe0
>     [<ffffffc000092734>] __dma_alloc_noncoherent+0x64/0x158
>     [<ffffffc000312cd8>] pl330_probe+0x650/0x8f0
>     [<ffffffc00030e1d4>] amba_probe+0xa0/0xc8
>     [<ffffffc000350240>] really_probe+0xc4/0x22c
>     [<ffffffc0003504b4>] __driver_attach+0xa0/0xa8
>     [<ffffffc00034e5fc>] bus_for_each_dev+0x54/0x98
>     [<ffffffc00034fd8c>] driver_attach+0x1c/0x28
>     [<ffffffc00034fa08>] bus_add_driver+0x14c/0x204
>     [<ffffffc000350b84>] driver_register+0x64/0x130
>     [<ffffffc00030dcf8>] amba_driver_register+0x50/0x5c
>     [<ffffffc0006a60d0>] pl330_driver_init+0x10/0x1c
>     [<ffffffc0000814ac>] do_one_initcall+0x88/0x19c
>     [<ffffffc00068dab8>] kernel_init_freeable+0x140/0x1e0
>     [<ffffffc0004e5e18>] kernel_init+0x10/0xd4
>     ---[ end trace 76f2d47a444e523e ]---
>     (NULL device *): dmac_alloc_resources:1821 Can't allocate memory!
>     (NULL device *): Unable to create channels for DMAC
> 
>     This patch will also ensure that any dev_err messages are printed
>     with the appropriate device name.
> 
>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
>     Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> 

