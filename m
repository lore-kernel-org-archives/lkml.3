Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaIYF4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 01:56:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:46429 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaIYF4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 01:56:42 -0400
X-AuditID: cbfee68d-f79296d000004278-c7-5423ae9329b6
From: Kukjin Kim <kgene@kernel.org>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Lorenzo Pieralisi'" <lorenzo.pieralisi@arm.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>
References: <5230569.XLlNbB5NvF@amdc1032>
In-reply-to: <5230569.XLlNbB5NvF@amdc1032>
Subject: RE: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
Date: Thu, 25 Sep 2014 14:56:33 +0900
Message-id: <018e01cfd885$770dd940$65298bc0$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJtyyXHa0BN3y769YFJ/MgOpaxA/prVcgrA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zI93J65RDDD6ut7HYOGM9q8Wmx9dY
	LS7vmsNmMeP8PiaLN79fsFusPXKX3WLp9YtMFpsnbGSzWLXrD6MDp8eaeWsYPXbOusvusXlJ
	vUffllWMHp83yQWwRnHZpKTmZJalFunbJXBlNJxfzVbwlaPiw7017A2M09m7GDk5JARMJK58
	fMQIYYtJXLi3nq2LkYtDSGAZo8T86Ufhij5MXAyVWMQoceXZA1YI5y+jxNWOd0BVHBxsAsoS
	jU36IA3CAloSC7c0sYDYIgLxElc+NLGD1DMLLGGSOPjpHxtIvZCApkTvfk0QkxOo/v2vdIhW
	B4mN/atYQMIsAqoS23oZQUxeAQuJW1cNQCp4BQQlfky+BzacGahx/c7jTBC2vMTmNW+ZIS5W
	kNhx9jUjxAFGEvufb2WEqBGR2PfiHSPIMRICjRwS8zedYQVJsAgISHybfAhsrYSArMSmA1Bz
	JCUOrrjBMoFRchaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ
	8d4djLcPWB9iFOBgVOLh/eCjHCLEmlhWXJl7iNEU6KKJzFKiyfnARJJXEm9obGZkYWpiamxk
	bmmmJM6rKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOj892dL3hKt/T+fnWuboa+0nuV
	l253Ljxb8uf5miUxvBVu2hUrN58vPqs8tVqtd7fhWe/Vggct7S2+7/nNwpuxuZ1rZT/rvT9i
	T+cFnL4280p+3Q8dnsRJtvM2Syl+/31n7ru7F/eabrEpc+Q+oMDFuFj0nUvrocaAwJrtd802
	ru1aeXuZd2KdnxJLcUaioRZzUXEiAIFFe9rsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd3J65RDDNa/NrfYOGM9q8Wmx9dY
	LS7vmsNmMeP8PiaLN79fsFusPXKX3WLp9YtMFpsnbGSzWLXrD6MDp8eaeWsYPXbOusvusXlJ
	vUffllWMHp83yQWwRjUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qba
	Krn4BOi6ZeYAHaSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzGg4v5qt
	4CtHxYd7a9gbGKezdzFyckgImEh8mLiYDcIWk7hwbz2QzcUhJLCIUeLKswesEM5fRomrHe+A
	Ojg42ASUJRqb9EEahAW0JBZuaWIBsUUE4iWufGhiB6lnFljCJHHw0z82kHohAU2J3v2aICYn
	UP37X+kQrQ4SG/tXsYCEWQRUJbb1MoKYvAIWEreuGoBU8AoISvyYfA9sODNQ4/qdx5kgbHmJ
	zWveMkNcrCCx4+xrRogDjCT2P9/KCFEjIrHvxTvGCYzCs5CMmoVk1Cwko2YhaVnAyLKKUTS1
	ILmgOCk910ivODG3uDQvXS85P3cTIziBPJPewbiqweIQowAHoxIPr4e/cogQa2JZcWXuIUYJ
	DmYlEV6fNUAh3pTEyqrUovz4otKc1OJDjKZAf05klhJNzgcmt7ySeENjEzMjSyMzCyMTc3Ml
	cd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYyTn7VPT9qSJPJfZmfE0j7m1Gtbrswrn2w1118j
	qCd4R9y9+yEJpyK3dXL/+y32ftdn6XfRRZ+73uuI/Dhdv8fuTH3sT3GtBSIcbq5JfyZf5Vh5
	YIH2R9mYtAMGTjNfvr2lW2VzQj9gid2Tyqg50xuEttYdZGWSOJ7+ehrLD/75sca2J6q/5HEo
	sRRnJBpqMRcVJwIAiPGaJjYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
> when topology is read from DT") fixed GIC driver to filter cluster ID
> from values returned by cpu_logical_map() for SoCs having registers
> mapped without per-CPU banking making it is possible to add CPU nodes
> for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
> required by future changes adding initialization of cpuidle states in
> Exynos cpuidle driver through DT.
> 
> Tested on Origen board (Exynos4210 SoC) and Trats2 (Exynos4412 SoC).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Based on for-next branch of linux-samsung.git tree.
> 
> v3:
> - refreshed on top of Kukjin's tree
> 
> v2:
> - match the unit-address with the reg
> 
>  arch/arm/boot/dts/exynos4210.dtsi |   17 +++++++++++++++++
>  arch/arm/boot/dts/exynos4212.dtsi |   17 +++++++++++++++++
>  arch/arm/boot/dts/exynos4412.dtsi |   29 +++++++++++++++++++++++++++++
>  3 files changed, 63 insertions(+)

Thanks for re-spin and looks good to me.

Applied.

Thanks,
Kukjin

