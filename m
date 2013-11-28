Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450Ab3K1TtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 14:49:13 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53551 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755994Ab3K1TtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 14:49:09 -0500
Date: Thu, 28 Nov 2013 19:47:51 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Olof Johansson <olof@lixom.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <Pawel.Moll@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v11 7/7] ARM: tegra: support Trusted Foundations by
 default
Message-ID: <20131128194751.GD4634@e103592.cambridge.arm.com>
References: <1385274652-16415-1-git-send-email-acourbot@nvidia.com>
 <1385274652-16415-8-git-send-email-acourbot@nvidia.com>
 <20131126000608.GA21634@quad.lixom.net>
 <CAAVeFu+mMyPhFtVZ09vgYWWCYkPpF3X547ffRAfXXKOOWUUkqg@mail.gmail.com>
 <20131126164730.GE2355@e103592.cambridge.arm.com>
 <CAAVeFuJgqgRnWLD+dyvb7+2fLanHmdDT0YV5r8ETsoqqjW8p7A@mail.gmail.com>
 <52977639.4000308@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52977639.4000308@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 04:58:33PM +0000, Stephen Warren wrote:
> On 11/27/2013 11:02 PM, Alexandre Courbot wrote:
> > On Wed, Nov 27, 2013 at 1:47 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> >> On Tue, Nov 26, 2013 at 10:35:58AM +0900, Alexandre Courbot wrote:
> >>> On Tue, Nov 26, 2013 at 9:06 AM, Olof Johansson <olof@lixom.net> wrote:
> >>>> On Sun, Nov 24, 2013 at 03:30:52PM +0900, Alexandre Courbot wrote:
> >>>>> Support for Trusted Foundations is light and allows the kernel to run on
> >>>>> a wider range of devices, so enable it by default.
> >>>>>
> >>>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >>>>> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> >>>>> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> >>>>> ---
> >>>>>  arch/arm/configs/tegra_defconfig | 1 +
> >>>>>  1 file changed, 1 insertion(+)
> >>>>
> >>>> I think we want this enabled on multi_v7_defconfig too? Send a separate
> >>>> patch for that once this is merged though.
> >>>
> >>> Will do.
> >>
> >> Should it just be default y if one of the relevant
> >> CONFIG_ARCH_TEGRA_*_SOC is selected?
> >>
> >> That way, it's automatically included if relevant, and automatically
> >> excluded if not -- regardless of whether the kernel is multiplatform
> >> or not.
> > 
> > So basically, that would mean setting the default to 'y' since the
> > option is not available unless a supported platform is included?
> > 
> > I'm fine this way too, if Stephen also agrees.
> 
> Fine by me.

Sure, as long as the result is right, that should be fine.

Cheers
---Dave
