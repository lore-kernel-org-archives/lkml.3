Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbaFYKhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:37:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35337 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaFYKhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:37:07 -0400
X-AuditID: cbfee690-b7fb56d000003439-3e-53aaa643a1e8
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Mike Turquette'" <mturquette@linaro.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Pankaj Dubey'" <pankaj.dubey@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
        "'Daniel Drake'" <drake@endlessm.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>
References: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
In-reply-to: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
Subject: RE: [PATCH v2 0/4] Add support for Exynos clock output configuration
Date: Wed, 25 Jun 2014 19:36:51 +0900
Message-id: <026001cf9061$5fef9d00$1fced700$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGKEpPdbK8juyUfB/569SOWiVVBf5wMmwlA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t8zI13nZauCDZqfyVtMffiEzeLR/MfM
	FpseX2O1uLxrDpvFjPP7mCzWHrnLbrH0+kUmi6cTLrJZLNr6hd1iyqLDrBate4+wWxx+085q
	sX7GaxaLVbv+MDrweayZt4bRY9H3LI+ds+6ye2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoAj
	issmJTUnsyy1SN8ugSuj70EXY8E/qYr7R1ezNTCuE+li5OSQEDCROHP1ECOELSZx4d56ti5G
	Lg4hgWWMEpPvHWeFKWqZe5IJIrGIUaLzyW42kISQwF9GicNdziA2m4CGxOH3z9hBbBEBT4kH
	pw6wgzQwC7xhlpi0pZ8dosFJYvne+WDrOAWcJSYdOwQ2SFjAV+LXtXtMIDaLgKrEkqUrWEBs
	XgFLiWtvj7BD2IISPybfA4szC2hJrN95nAnClpfYvOYtM8SlChI7zr5mhDjCSGLD3INQ9SIS
	+168YwQ5SEJgC4fEl+XHWCGWCUh8m3wIqIgDKCErsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZ
	PQvJigWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQhLEhB2M9w5YH2JMBlo/kVlKNDkf
	mGDySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	7l/O2Wf2me7gjl38cJHeqeBJ7nIGvauszLQCX8rpfvq63E0+avn7BHvLD0lTa64uYN30YPcZ
	sSKZAm4Z3pm/Es+tzRVOKb6Yo7E2b7/B+oaqlHMfnbi6ejeEMNec69NIuFGXxd6+oVGjPIb7
	S8vrpZq28hcYCnxtDh8vtVsgkR6gUztRXUCJpTgj0VCLuag4EQATrwPzJgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEKsWRmVeSWpSXmKPExsVy+t9jAV3nZauCDVZ9lbKY+vAJm8Wj+Y+Z
	LTY9vsZqcXnXHDaLGef3MVmsPXKX3WLp9YtMFk8nXGSzWLT1C7vFlEWHWS1a9x5htzj8pp3V
	Yv2M1ywWq3b9YXTg81gzbw2jx6LvWR47Z91l99i0qpPN4861PWwem5fUe/RtWcXo8XmTXABH
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q3UoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjL4HXYwF/6Qq7h9dzdbAuE6k
	i5GTQ0LARKJl7kkmCFtM4sK99WxdjFwcQgKLGCU6n+xmA0kICfxllDjc5QxiswloSBx+/4wd
	xBYR8JR4cOoAO0gDs8AbZolJW/rZIRqcJJbvnc8IYnMKOEtMOnYIbJCwgK/Er2v3wLaxCKhK
	LFm6ggXE5hWwlLj29gg7hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkNcqiCx4+xrRogjjCQ2
	zD0IVS8ise/FO8YJjEKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOP08k9rBuLLB4hCjAAejEg/vhdkrg4VYE8uKK3MPMUpwMCuJ8DrOWRUsxJuSWFmVWpQf
	X1Sak1p8iNEU6NOJzFKiyfnA1JhXEm9obGJmZGlkZmFkYm6uJM57oNU6UEggPbEkNTs1tSC1
	CKaPiYNTqoFRod7gfer5vNC3/bIeYtpn95dfUpp/c25ITt2E9+ZhxxrjfYyuPs2c1cnXYfCA
	p5gzxuRhtnbDqSVPBBdpXbbfc7ZfO+yW5znts8sTznC+fvPE/B2/s1fK3KQQNpGSIwta5rNY
	p5t4GqcGOPaw/GD1v6a07HODVkPH7JrY3/9eXa4//TA+o1+JpTgj0VCLuag4EQAb8f2vVQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Figa wrote:
> 
Hi Tomasz,

> On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
> internal SoC clocks to be output from the SoC. The hardware structure

Yeah, because the CLKOUT pin is used for measure of the clock for debug on all
of exynos SoCs commonly.

> of CLKOUT related clocks looks as follows:
> 
> 	CMU	|---> clock0 --------->	|	PMU	|
> 		|			|		|
>     several	|---> clock1 ---------> |	mux	|
>     muxes	|			|	+	|---> CLKOUT
>     dividers	|       ...		|	gate	|
>     and gates	|			|		|
> 		|---> clockN ---------> |		|
> 
> Since the block responsible for handling the pin is PMU, not CMU,
> a separate driver, that binds to PMU node is required and acquires
> all input clocks by standard DT clock look-up. This way we don't need
> any cross-IP block drivers and cross-driver register sharing or
> nodes for fake devices.
> 
BTW, upcoming exynos5 SoCs have two muxs for CLKOUT and each mux is controlled
by CMU and PMU, so

The mux1 for CLKOUT in CMU is used to decide which clock in each sub-domain
will be out and the mux2 in PMU is used to decide which sub-domain will be out
via CLKOUT. So I want you to consider of all of exynos SoCs including upcoming
SoCs.

Thanks,
Kukjin

> To represent the PMU mux/gate clock, generic composite clock is registered.
> 
> Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
> with some additional patches.
> 
> Changes since v1:
> (http://www.spinics.net/lists/arm-kernel/msg333276.html)
>  - rebased onto next-20140624,
>  - fixed #clock-cells values in exynos5250.dtsi and exynos5420.dtsi,
>  - temporarily removed ISP CLKOUT clocks on Exynos4x12, until ISP clock
>    domain handling gets fixed in Exynos4 clock driver.
> Changes since RFC v1:
> (https://lkml.org/lkml/2014/5/15/506)
>  - rebased onto v5 of "Enable usbphy and hsotg for exynos4" series and
>    current HEAD of samsung-clk tree,
>  - added handling of suspend/resume in the driver,
>  - added missing CPU clocks on Exynos4,
>  - added CLK_SET_RATE_PARENT to CMU CLKOUT gates on Exynos4,
>  - fixed bit field width on Exynos4,
>  - added CLKOUT CMU registers of Exynos4 to save/restore list,
>  - added CLK_SET_RATE_PARENT and CLK_SET_RATE_NO_REPARENT to clkout clock,
>  - changed the binding to use 1-cell clock specifier to allow extension
>    with further PMU clocks in future, if needed.
> 
> Tomasz Figa (4):
>   clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
>   clk: samsung: exynos4: Add CLKOUT clock hierarchy
>   clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
>   ARM: dts: exynos: Update PMU node with CLKOUT related data
> 
>  .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |  10 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
>  arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
>  arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
>  drivers/clk/samsung/Makefile                       |   1 +
>  drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++
>  drivers/clk/samsung/clk-exynos4.c                  | 166
++++++++++++++++++++-
>  include/dt-bindings/clock/exynos4.h                |   5 +
>  9 files changed, 374 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c
> 
> --
> 1.9.3

