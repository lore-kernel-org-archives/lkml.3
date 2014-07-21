Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaGUMn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:43:57 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48230 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaGUMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <1863399.9O2S91ZvEO@amdc1032>
References: <1863399.9O2S91ZvEO@amdc1032>
Date: Mon, 21 Jul 2014 13:43:53 +0100
Message-ID: <CAD8Lp46eB3cDqD+1YMnWOG-V8CG7fCG1s2KH7znL0OrHSazRcQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: add CPU nodes for Exynos4 SoCs
From: Daniel Drake <drake@endlessm.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tomasz Figa <t.figa@samsung.com>, thomas.ab@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 5:00 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
> Recent patch by Tomasz Figa ("irqchip: gic: Fix core ID calculation
> when topology is read from DT") fixed GIC driver to filter cluster ID
> from values returned by cpu_logical_map() for SoCs having registers
> mapped without per-CPU banking making it is possible to add CPU nodes
> for Exynos4 SoCs.  In case of Exynos SoCs these CPU nodes are also
> required by future changes adding initialization of cpuidle states in
> Exynos cpuidle driver through DT.

This conflicts with work in the thread "cpufreq: use generic cpufreq
drivers for exynos platforms" which is already in its 7th iteration.
Perhaps best to work directly with Thomas to help him finish that series?

Daniel
