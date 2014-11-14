Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109AbaKNGKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 01:10:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:51957 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaKNGK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 01:10:28 -0500
X-AuditID: cbfee68f-f791c6d000004834-f5-54659cd1f390
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Nicolas Pitre'" <nicolas.pitre@linaro.org>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        james.hogan@imgtec.com, ccross@android.com
References: <1415857098-16928-1-git-send-email-pankaj.dubey@samsung.com>
 <alpine.LFD.2.11.1411131231060.11690@knanqh.ubzr>
 <20141113174837.GB4042@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1411131259330.11690@knanqh.ubzr>
In-reply-to: <alpine.LFD.2.11.1411131259330.11690@knanqh.ubzr>
Subject: RE: [PATCH] ARM: b.L: fix unmet dependency for CPU_PM
Date: Fri, 14 Nov 2014 11:40:06 +0530
Message-id: <001401cfffd1$ae9df930$0bd9eb90$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKGmaKPqYA4YYy5jNaU5xjD4fUpjQKd/gMfAsMOuwkC6gmqppqwEeDg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkRvfinNQQg7MdUhbbN35jtXg37wWz
	xabH11gtLu+aw2Zx+zKvxadn/9gd2Dy27d7G6tHS3MPm0bPzDKPHnWt72Dw2L6n3+LxJLoAt
	issmJTUnsyy1SN8ugSvjx+ktbAVfhCoatm9kaWC8yNfFyMkhIWAi8fXwbRYIW0ziwr31bCC2
	kMBSRonPX4Rham5s+8vaxcgFFF/EKDGz+RUzhPOXUeJ19y9WkCo2AV2JJ+/nAiU4OEQEUiV2
	nCgFCTMLlEi0N+yHan4INPTjfbBtnAJ2Es9OngezhYHsd7snMYLYLAKqEi+m9jGD2LwClhI7
	j11gh7AFJX5MvscCMVRLYv3O40wQtrzE5jVvmSEuVZDYcfY12BwRATeJB4/vQtWLS0x68JAd
	5AgJgUfsEttvvGKCWCYg8W3yIRaQoyUEZCU2HYCaIylxcMUNlgmMErOQrJ6FZPUsJKtnIVmx
	gJFlFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZg7J7+96x/B+PdA9aHGAU4GJV4eBncUkOE
	WBPLiitzDzGaAl00kVlKNDkfmCDySuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1I
	LYovKs1JLT7EyMTBKdXA2H735+oZ+9UktO6ePOewquTJ2qdOs08EllvfTn1zZz2vlNd+z8xf
	llmSt+YcvetvsofbzFihblfMieP7ll65IK/5fN7lIhXxt3/9dztGcxrv2PTAoWKRc/SEby5p
	V5tWrFscJxB9K/h7zmu1x2u/B0lfnbI/7Nt33gqmLRffrT19pboyTP+f5wolluKMREMt5qLi
	RACzNwmk2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd2Lc1JDDBb8ErDYvvEbq8W7eS+Y
	LTY9vsZqcXnXHDaL25d5LT49+8fuwOaxbfc2Vo+W5h42j56dZxg97lzbw+axeUm9x+dNcgFs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM36c3sJW8EWoomH7RpYGxot8
	XYycHBICJhI3tv1lhbDFJC7cW8/WxcjFISSwiFFiZvMrZgjnL6PE6+5fYFVsAroST97PBUpw
	cIgIpErsOFEKEmYWKJFob9jPClH/kFHi88f7LCAJTgE7iWcnz4PZwkD2u92TGEFsFgFViRdT
	+5hBbF4BS4mdxy6wQ9iCEj8m32OBGKolsX7ncSYIW15i85q3zBCXKkjsOPsabI6IgJvEg8d3
	oerFJSY9eMg+gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525i
	BKeGZ1I7GFc2WBxiFOBgVOLhZXBLDRFiTSwrrsw9xCjBwawkwrtgNlCINyWxsiq1KD++qDQn
	tfgQoynQpxOZpUST84FpK68k3tDYxNzU2NTSxMLEzFJJnPdAq3WgkEB6YklqdmpqQWoRTB8T
	B6dUA2PaLTHzeef0L0gqNUrcYrdbe/L6XJmGPStyA2bsVVjRr68of0zvkouTeiDD9oStq1hs
	8ma9MzHunngoZG5f66JtP9boTWt6VrYl00PrPNuXRK2nP+Z73VROORU4VW1LuOEl3aK1ossW
	NESWKa0z4/rvWeBZ3v1YQtIuqvPwRw9m1v9TH26OeqvEUpyRaKjFXFScCACbK8QEIwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC: Colin Cross, James Hogan

On Thursday, November 13, 2014 11:30 PM, Nicolas Pitre wrote:
> To: Russell King - ARM Linux
> Cc: Pankaj Dubey; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] ARM: b.L: fix unmet dependency for CPU_PM
> 
> On Thu, 13 Nov 2014, Russell King - ARM Linux wrote:
> 
> > On Thu, Nov 13, 2014 at 12:44:22PM -0500, Nicolas Pitre wrote:
> > > On Thu, 13 Nov 2014, Pankaj Dubey wrote:
> > >
> > > > If BL_SWITCHER is enabled but SUSPEND and CPU_IDLE is not enabled
> > > > we are getting following config warning.
> > > >
> > > > warning: (BL_SWITCHER) selects CPU_PM which has unmet direct
> > > > dependencies (SUSPEND || CPU_IDLE)
> > > >
> > > > So BL_SWITCHER should enable CPU_PM only if either of SUSPEND or
> > > > CPU_IDLE is selected.
> > > >
> > > > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> > > > ---
> > > >  arch/arm/Kconfig |    2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig index
> > > > 9d580d0..fe3d969 100644
> > > > --- a/arch/arm/Kconfig
> > > > +++ b/arch/arm/Kconfig
> > > > @@ -1417,7 +1417,7 @@ config BL_SWITCHER
> > > >  	bool "big.LITTLE switcher support"
> > > >  	depends on BIG_LITTLE && MCPM && HOTPLUG_CPU
> > > >  	select ARM_CPU_SUSPEND
> > > > -	select CPU_PM
> > > > +	select CPU_PM if (SUSPEND || CPU_IDLE)
> > >
> > > NAK.  You just broke the code by doing this. CPU_PM is a requirement
> > > here.  The dependencies for CPU_PM is lacking.
> >

OK, got it. Even though compilation worked, but as you mentioned by doing
this way
bL_switcher functionality may broke.

> > Is there any real technical reason that CPU_PM depends on SUSPEND ||
> > CPU_IDLE ?  If not, those dependencies should be killed.
> 
> Those dependencies look artificial to me.
> 

For me also it looks like these dependencies are artificial.
As far as I can see CONFIG_CPU_PM compiles following two files 
1: kernel/cpu_pm.c - I can't see any dependency of SUSPEND or CPU_IDLE in
this file.
2: arch/mips/kernel/pm.c: A quick look does not show any dependency of
SUSPEND or
   CPU_IDLE here too.

So for me it looks like it is OK to kill these dependencies of CPU_PM. 
Still safer side I am CCing this to author of these files for confirmation.

Thanks,
Pankaj Dubey
> 
> Nicolas

