Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbaIDFDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 01:03:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29647 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaIDFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 01:03:15 -0400
X-AuditID: cbfee68f-f797f6d000001173-7d-5407f2917826
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Will Deacon'" <will.deacon@arm.com>,
        NAVEEN KRISHNA CHATRADHI <ch.naveen@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, naushad@samsung.com,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>, robh+dt@kernel.org,
        thomas.ab@samsung.com
References: <1409629756-14304-1-git-send-email-pankaj.dubey@samsung.com>
 <20140902084214.GE25379@arm.com>
In-reply-to: <20140902084214.GE25379@arm.com>
Subject: RE: [RESEND PATCH] arm64: dts: add <dt-bindings/> symlink
Date: Thu, 04 Sep 2014 10:35:28 +0530
Message-id: <002801cfc7fd$d9c5b5a0$8d5120e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFIUHAbXakzor/NOaPkTWAeyC6jkgHki6lDnPAza3A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWyRsSkWnfiJ/YQg7YN3Bbvl/UwWtx9fpjR
	Yv6Rc6wWmx5fY7W4vGsOm8Wno/9ZLVr3HmG36FjGaPHy4wkWB06PNfPWMHpsWtXJ5rF5Sb1H
	35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZdw5dZaxoJO74ln3frYGxk7OLkZODgkBE4nrU56z
	Q9hiEhfurWfrYuTiEBJYyihxbMNVFpiiLQf7mCES0xklVrbvYIJw/jJK3Ny9iA2kik1AV+LJ
	+7nMILaIQLTElB1LGEGKmAWuMko8XfoJbJSQQLbE6cadYA2cQA3LztwF2y0s4CRxfk8rmM0i
	oCoxc+sZsHpeAUuJhbd2M0HYghI/Jt8DizMLaEms33mcCcKWl9i85i0zxKkKEjvOvmaEOMJK
	4tXvGVD14hKTHjxkBzlIQuAju0T7n1ssEMsEJL5NPgRkcwAlZCU2HYCaIylxcMUNlgmMErOQ
	rJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZgTJ/+96x/B+PdA9aH
	GAU4GJV4eAtesIcIsSaWFVfmHmI0BbpoIrOUaHI+MHHklcQbGpsZWZiamBobmVuaKYnzLpT6
	GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBUeNBcvHKYPHA64Z172t+fjmfpDXn8SLP9wmc
	cxqeLsltfiu+K0O8MHG/yo0PC1/MeuVus4Rxi5nYnFV1NnvO9NvlPVy+1FVuRvrUSClj6/9T
	LvUv1DH5Wjhtz/NA+91HWbq111kdkfZevHjmFvflzieumYpwNF1z9LTv1dKV/DXp0rrtfz+y
	ZSuxFGckGmoxFxUnAgDFAYjF5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd2Jn9hDDJYeZ7Z4v6yH0eLu88OM
	FvOPnGO12PT4GqvF5V1z2Cw+Hf3PatG69wi7RccyRouXH0+wOHB6rJm3htFj06pONo/NS+o9
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGnVNnGQs6
	uSuede9na2Ds5Oxi5OSQEDCR2HKwjxnCFpO4cG89WxcjF4eQwHRGiZXtO5ggnL+MEjd3L2ID
	qWIT0JV48n4uWIeIQLTElB1LGEGKmAWuMko8XfqJBSQhJJAtcbpxJ1gDJ1DDsjN32UFsYQEn
	ifN7WsFsFgFViZlbz4DV8wpYSiy8tZsJwhaU+DH5HlicWUBLYv3O40wQtrzE5jVvoU5VkNhx
	9jUjxBFWEq9+z4CqF5eY9OAh+wRGoVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yY
	W1yal66XnJ+7iRGcMJ5J7WBc2WBxiFGAg1GJh7fgBXuIEGtiWXFl7iFGCQ5mJRHe2WeBQrwp
	iZVVqUX58UWlOanFhxhNgT6dyCwlmpwPTGZ5JfGGxibmpsamliYWJmaWSuK8B1qtA4UE0hNL
	UrNTUwtSi2D6mDg4pRoYO5bzsZ7fsuyRDB/n/7kN3ifW71W7v2TijmjmxLX6bDEbX5/9qe6c
	oLfYofWwtdihtU/EF62erZSbc/2lVxKr4vEZf+9tsrzHtGSStFL6Ao1f8323KN+avs045Ear
	a3zu3z3anL7/j68zXqEuxn1Eb3X8L0sn7bc2d9tlxH15OHMMBP9xbdpXqMRSnJFoqMVcVJwI
	APtoybEuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Will Deacon [mailto:will.deacon@arm.com]
> Sent: Tuesday, September 02, 2014 2:12 PM
> To: Pankaj Dubey
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org;
> devicetree@vger.kernel.org; naushad@samsung.com; Catalin Marinas;
> robh+dt@kernel.org; thomas.ab@samsung.com
> Subject: Re: [RESEND PATCH] arm64: dts: add <dt-bindings/> symlink
> 
> On Tue, Sep 02, 2014 at 04:49:16AM +0100, Pankaj Dubey wrote:
> > Add symlink to include/dt-bindings from arch/arm64/boot/dts/include/
> > to match the ones in ARM architectures so that preprocessed device
> > tree files can include various useful constant definitions.
> >
> > See commit c58299aa8754 ("kbuild: create an "include chroot" for DT
> > bindings") merged in v3.10-rc1 for details.
> >
> > CC: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >
> > Resubmitting this change as now it will be required for Samsung ARM64
> > based SoC.
> 
> Just include this change in the series adding a .dts that needs it -- it
doesn't really
> make sense in isolation (unless somebody desperately wants this in?).
> 

OK, we will include this patch in series adding a .dts that needs it in next
respin.

@Naveen: Please include this patch whenever you are respinning Exynos7 dts
patches.

Thanks,
Pankaj Dubey
> Will

