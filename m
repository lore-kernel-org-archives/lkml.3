Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaIYIRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:17:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46329 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIYIRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:17:13 -0400
Date: Thu, 25 Sep 2014 09:17:04 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "'Thomas Abraham'" <ta.omasab@gmail.com>, daniel.lezcano@linaro.org
Subject: Re: [PATCH v3] ARM: dts: add CPU nodes for Exynos4 SoCs
Message-ID: <20140925081704.GA20841@e102568-lin.cambridge.arm.com>
References: <5230569.XLlNbB5NvF@amdc1032>
 <018e01cfd885$770dd940$65298bc0$@kernel.org>
MIME-Version: 1.0
In-Reply-To: <018e01cfd885$770dd940$65298bc0$@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Sep 2014 08:17:08.0675 (UTC) FILETIME=[19849930:01CFD899]
X-MC-Unique: 114092509171100701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ed Daniel to make him aware this patch goes through your tree]

On Thu, Sep 25, 2014 at 06:56:33AM +0100, Kukjin Kim wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > 
> > Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
> > when topology is read from DT") fixed GIC driver to filter cluster ID
> > from values returned by cpu_logical_map() for SoCs having registers
> > mapped without per-CPU banking making it is possible to add CPU nodes
> > for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
> > required by future changes adding initialization of cpuidle states in
> > Exynos cpuidle driver through DT.
> > 
> > Tested on Origen board (Exynos4210 SoC) and Trats2 (Exynos4412 SoC).
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > ---
> > Based on for-next branch of linux-samsung.git tree.
> > 
> > v3:
> > - refreshed on top of Kukjin's tree
> > 
> > v2:
> > - match the unit-address with the reg
> > 
> >  arch/arm/boot/dts/exynos4210.dtsi |   17 +++++++++++++++++
> >  arch/arm/boot/dts/exynos4212.dtsi |   17 +++++++++++++++++
> >  arch/arm/boot/dts/exynos4412.dtsi |   29 +++++++++++++++++++++++++++++
> >  3 files changed, 63 insertions(+)
> 
> Thanks for re-spin and looks good to me.
> 
> Applied.

That's great, now my Exynos CPUidle DT patch should be rebased on top
of this patch so that thanks to the testing carried out by Bart it can be
merged too.

Lorenzo

