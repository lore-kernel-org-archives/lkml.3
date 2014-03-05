Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaCEI61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:58:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10835 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaCEI6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:58:25 -0500
X-AuditID: cbfee68e-b7f566d000002344-30-5316e72edc51
From: Jingoo Han <jg1.han@samsung.com>
To: "'Liviu Dudau'" <liviu@dudau.co.uk>
Cc: "'Liviu Dudau'" <Liviu.Dudau@arm.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Catalin Marinas'" <Catalin.Marinas@arm.com>,
        "'Will Deacon'" <Will.Deacon@arm.com>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, devicetree@vger.kernel.org,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>,
        "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-8-git-send-email-Liviu.Dudau@arm.com>
 <001f01cf3811$18463ed0$48d2bc70$%han@samsung.com>
 <20140305083311.GD13582@bart.dudau.co.uk>
In-reply-to: <20140305083311.GD13582@bart.dudau.co.uk>
Subject: Re: [PATCH v5 7/7] pci: Add support for creating a generic host_bridge
 from device tree
Date: Wed, 05 Mar 2014 17:58:22 +0900
Message-id: <000b01cf3851$0fe55d30$2fb01790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac84TcXYT1YzZ5eMTLOBZpdwN7pp7AAAZnSg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t8zfV2952LBBiu/WFv8nXSM3eJDUyuz
	xZKmDIv3y3oYLeYfOcdqcXnhJVaL94eeMVtsenwNyN01h83i7LzjbBYHlrazWPxdfJjF4vmn
	TywWLz+eYHHg8/i4/hOjx5p5axg9fv+axOjxY/9XVo8Fm0o9et60sHpsXlLvcfvfY2aPvi2r
	GD0+b5IL4IrisklJzcksSy3St0vgyrj36Q9TwQ6BitPdyg2Mm3i7GDk5JARMJD7MWcYOYYtJ
	XLi3nq2LkYtDSGAZo8SHkzcYYYr+tM1mgUgsYpSYPP8CK4Tzm1Hi24RrrCBVbAJqEl++HAYa
	xcEhIqAqsfwhM0gNs8BCFomeN98YIRruMkr8uXeSGaSBU8BMYkLrJzBbWCBJYva7S8wgzSxA
	zfuafUHCvAK2Er/2bGeCsAUlfky+xwJSwiygLjFlSi5ImFlAXmLzmrdgnRJA4Ud/dUHCIgJG
	EjM2fmaHKBGR2PfiHdQvRzgkThyIB7FZBAQkvk0+xALRKiux6QAzRImkxMEVN1gmMErMQrJ3
	FsLeWUj2zkKyYAEjyypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkETRt4Px5gHrQ4zJQNsn
	MkuJJucDE01eSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamCcvZjX0/ieWNvhmYvD17scyYs6V5fLdUzsAmPrTFurBfpGKeuPqi2c7jFxd3bgaT4/
	A591u55e/HygrkZC8Hp5+Jaj3HOZHzNPtDh4N9A1ptrV/fjBrDnuOev3sL2Xmrtua5HLsjfX
	+ta92nVq4aFf2acKlJbN+z7H04C7u89UraJXsG+R18cuJZbijERDLeai4kQAIhCnACoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsVy+t9jAV2952LBBltmmln8nXSM3eJDUyuz
	xZKmDIv3y3oYLeYfOcdqcXnhJVaL94eeMVtsenwNyN01h83i7LzjbBYHlrazWPxdfJjF4vmn
	TywWLz+eYHHg8/i4/hOjx5p5axg9fv+axOjxY/9XVo8Fm0o9et60sHpsXlLvcfvfY2aPvi2r
	GD0+b5IL4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMAXpASaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx79MfpoIdAhWn
	u5UbGDfxdjFyckgImEj8aZvNAmGLSVy4t56ti5GLQ0hgEaPE5PkXWCGc34wS3yZcYwWpYhNQ
	k/jy5TB7FyMHh4iAqsTyh8wgNcwCC1kket58Y4RouMso8efeSWaQBk4BM4kJrZ/AbGGBJInZ
	7y4xgzSzADXva/YFCfMK2Er82rOdCcIWlPgx+R4LSAmzgLrElCm5IGFmAXmJzWvegnVKAIUf
	/dUFCYsIGEnM2PiZHaJERGLfi3eMExiFZiEZNAth0Cwkg2Yh6VjAyLKKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIzgRPZPawbiyweIQowAHoxIP7wsOsWAh1sSy4srcQ4wSHMxKIrzPHwGF
	eFMSK6tSi/Lji0pzUosPMSYDfTmRWUo0OR+YJPNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgbGta6KO8J0Tk2qmVr2Uatr4PXzCrZVfFv+e7rww9PE/yaXW
	U7d6VFVwJv0MSmvewnxG9mav7bzCQ9OmX1Uxacj80b5pVYDMZKt3Pp/3R7xqnNBtUDAtepvR
	HsOag2du718aIX2jXyvoRvGK1ZWJz2rZKp5JJbzVNz5akqpbvHzCfj5574WnpzAosRRnJBpq
	MRcVJwIABK+dQ4gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 5:33 PM, Liviu Dudau wrote:
> On Wed, Mar 05, 2014 at 10:20:28AM +0900, Jingoo Han wrote:
> > On Wednesday, March 05, 2014 12:50 AM, Liviu Dudau wrote:
> > >
> > > Several platforms use a rather generic version of parsing
> > > the device tree to find the host bridge ranges. Move the common code
> > > into the generic PCI code and use it to create a pci_host_bridge
> > > structure that can be used by arch code.
> > >
> > > Based on early attempts by Andrew Murray to unify the code.
> > > Used powerpc and microblaze PCI code as starting point.
> > >
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > >
> > > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > > index 8708b652..800678a 100644
> > > --- a/drivers/pci/host-bridge.c
> > > +++ b/drivers/pci/host-bridge.c

[.....]

> > > +
> > > +	/* Apply architecture specific fixups for the ranges */
> > > +	pcibios_fixup_bridge_ranges(resources);
> >
> > It also makes compile problem with exynos_defconfig as below:
> >
> > drivers/built-in.o: In function `pci_host_bridge_of_get_ranges':
> > drivers/pci/host-bridge.c:157: undefined reference to `pcibios_fixup_bridge_ranges'
> 
> Does that mean that exynos_defconfig doesn't define CONFIG_OF? How do you
> compile all the .dts files then? Should CONFIG_OF not be added to the default config
> file?

Now, I am testing your patches with ARM32 platform such as
Exynos SoCs. And the default 'exynos_defconfig' already defines
CONFIG_OF=y. (./arch/arm/configs/exynos_defconfig)

> 
> Other than that, your comment is correct. drivers/pci/host-bridge.c gets compiled
> in regardless of CONFIG_OF and I need to provide an empty implementation for
> pcibios_fixup_bridge_ranges().

There is no pcibios_fixup_bridge_ranges() in ./arch/arm/ directory.
So, it makes the compile problem.

I think that the empty implementation for pcibios_fixup_bridge_ranges()
may be necessary, in order to the compile problem.
Or, __weak pcibios_fixup_bridge_ranges() would be used.

Best regards,
Jingoo Han

