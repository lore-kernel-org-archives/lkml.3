Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbaGEGan (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:30:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25575 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaGEGal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:30:41 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-28-53b79b8e5eff
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, vikas.sajjan@samsung.com,
        joshi@samsung.com, naushad@samsung.com, thomas.ab@samsung.com,
        chow.kim@samsung.com
References: <1403705032-14835-1-git-send-email-pankaj.dubey@samsung.com>
 <1403705032-14835-2-git-send-email-pankaj.dubey@samsung.com>
 <53B18C46.9010405@samsung.com>
In-reply-to: <53B18C46.9010405@samsung.com>
Subject: RE: [PATCH v5 1/5] ARM: EXYNOS: Add support for mapping PMU base
 address via DT
Date: Sat, 05 Jul 2014 12:01:19 +0530
Message-id: <001b01cf981a$bd5dda90$38198fb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQK9JhWRh3pvFez7a+k3zuvbSuvV7QEiXn8uAdPPTFGZnjYv8A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWyRsSkSrdv9vZgg32LNSyWTbrLZvF91xd2
	i94FV9ksNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/Vov1M16zWHQsY7S4+Ww7kwO3R0tzD5vH
	5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx+1Ybc8ETwYoZh/rYGhjP8XYxcnJICJhI
	/H34iAXCFpO4cG89G4gtJLCUUWL+8xSYmn03DjB2MXIBxaczSjTs3cEE4fxllPjzuhWsg01A
	V+LJ+7nMIAkRgX5GidmN59hAHGaBJYwSe2acgupfwShx8HIDI0gLp4C2xIR5m8FsYYEoib1L
	W1m7GDk4WARUJT49kwcxeQUsJRYfzgWp4BUQlPgx+R7YqcwCWhLrdx5ngrDlJTavecsMcaqC
	xI6zr8Emigg4SUy784wdokZcYtKDh+wgJ0gItHJIPN7QC3Y1i4CAxLfJh1hAdkkIyEpsOgA1
	R1Li4IobLBMYJWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CIjveLE3OLSvHS95PzcTYzA
	yD7971nfDsabB6wPMSYDrZ/ILCWanA9MDHkl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgXGB3OVo2ev7tvZXaHg+WM/5La4uMDaxxv7iKYlPAkZ2
	Vd+PGc7J25Z/9+fdalbOWg2PkC/eGw71enw9t+dMU01+kOSVowrOSWnXF+mmP98Sb75+htW+
	OMbKQ0vcDR02T9tS2nDhR42Pz8nbmSwnd8ytNpV/sC7NTGrib7kot0bXmv83Nz1V6lViKc5I
	NNRiLipOBAB898hAAgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd2+2duDDSZPlLdYNukum8X3XV/Y
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS3Wz3jNYtGxjNHi5rPtTA7cHi3NPWwe
	m5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5i
	bqqtkotPgK5bZg7QTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjN23
	2pgLnghWzDjUx9bAeI63i5GTQ0LARGLfjQOMELaYxIV769m6GLk4hASmM0o07N3BBOH8ZZT4
	87qVDaSKTUBX4sn7ucwgCRGBfkaJ2Y3nwFqYBZYwSuyZcYoRomUFo8TByw1ggzkFtCUmzNsM
	ZgsLREnsXdrK2sXIwcEioCrx6Zk8iMkrYCmx+HAuSAWvgKDEj8n3WEBsZgEtifU7jzNB2PIS
	m9e8ZYY4VUFix9nXYBNFBJwkpt15xg5RIy4x6cFD9gmMQrOQjJqFZNQsJKNmIWlZwMiyilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4cTyT3sG4qsHiEKMAB6MSD6/CsW3BQqyJZcWVuYcY
	JTiYlUR4K0K2BwvxpiRWVqUW5ccXleakFh9iNAX6cyKzlGhyPjCp5ZXEGxqbmJsam1qaWJiY
	WSqJ8x5stQ4UEkhPLEnNTk0tSC2C6WPi4JRqYIyXe2Pe8Mhkv/vZ5e+9SyZ1tXDn3LvxpkZQ
	wysg7cn3cpHEbRWrl6VP3Xmr4Ob/7p+arYZZRzq25bAsX/L/zFQl1WOXnobr3/zleo31ctb+
	gPeL/3V8fnz6+rRLvBVGf9JYl7wsmHnv9kmnyd5LuwOva2avPn5lVyKLptjNi0kSAuXC1hYb
	NZuVWIozEg21mIuKEwFw0fAQMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Monday, June 30, 2014 Tomasz Figa wrote:
> 
> Hi Pankaj,
> 
> In general the patch seems quite nice, but please see few comments inline.
> 
> On 25.06.2014 16:03, Pankaj Dubey wrote:
> > Add support for mapping Samsung Power Management Unit (PMU) base
> > address from device tree.
> >
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > ---
> >  arch/arm/mach-exynos/common.h |    1 +
> >  arch/arm/mach-exynos/exynos.c |   45
> +++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> 
> [snip]
> 
> > +static void exynos_map_pmu(void)
> > +{
> > +	struct device_node *np = NULL;
> 
> nit: Unnecessary variable initialization.
>

OK, will correct it.
 
> > +
> > +	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
> > +
> 
> nit: Unnecessary blank line.
> 

OK, will remove this.

> > +	if (!np) {
> > +		pr_err("Failed to find PMU node\n");
> > +		return;
> 
> Returning here probably doesn't make too much sense, especially when you
just panic
> if the mapping fails and you remove the static mapping in patch 2/5, so
backwards
> compatibility isn't provided anyway.
> 
> So something like this might be a better idea:
> 
> 	np = of_find_matching_node(NULL, exynos_dt_pmu_match);
> 	if (np)
> 		pmu_base_addr = of_iomap(np, 0);
> 
> 	if (!pmu_base_addr)
> 		panic("failed to find exynos pmu register\n");
> 

Yes, this will be better. I will modify this part.

> > +	}
> > +
> > +	pmu_base_addr = of_iomap(np, 0);
> > +
> > +	if (!pmu_base_addr)
> > +		panic("failed to find exynos pmu register\n"); }
> > +
> > +static void __init exynos_init_time(void) {
> > +	/* Nothing to do timer specific.
> > +	 * Since platsmp.c needs pmu base address by the time
> > +	 * DT is not unflatten so we can't use DT APIs before
> > +	 * init_time
> > +	 */
> > +	exynos_map_pmu();
> 
> Would moving this to .init_irq() callback work too? There are more things
happening
> in .init_time() so it seems more fragile and some platforms (e.g.
mach-tegra) do such
> platform-specific initialization in
> .init_irq() instead.
> 

I need to check this, if it works I will update as suggested.

> Best regards,
> Tomasz

Thanks,
Pankaj Dubey

