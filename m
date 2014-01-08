Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaAHPVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:21:24 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52733 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359AbaAHPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:21:21 -0500
Date: Wed, 8 Jan 2014 15:20:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v2 0/9] CPU enable method based SMP/hotplug + MSM
 conversion
Message-ID: <20140108152049.GD11753@e106331-lin.cambridge.arm.com>
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org>
 <52CB2BDF.9040208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CB2BDF.9040208@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jan 06, 2014 at 10:19:11PM +0000, Stephen Boyd wrote:
> Ping? Can anyone take a look at the generic ARM and DT binding patches
> and provide acks/reviews? I'd like to send this through arm-soc via the
> MSM tree if possible.

Apologies for the delay. It's taking a while to warm up after christmas.

> 
> On 12/23/13 16:39, Stephen Boyd wrote:
> > This is a rework of patches sent a months back by Rohit[1].
> > The goal of these patches is to add support for SMP and (basic)
> > hotplug on MSM based SoCs. To get there, we add support for a
> > generic way to hook in SMP/hotplug support code based on DT. To
> > show how it's used, we convert the MSM8660 SMP support code over
> > to the new method. After that we add support for the rest of the
> > upstream MSM SoCs (note these patches are piled high on top of
> > Rohit's patches to add 8074 support to MSM[2] and my follow ups[3,4],
> > but this should only matter to the MSM maintainers).
> >
> > This is one of the last items of code that still requires us to have
> > a mach directory and a machine descriptor. We should be able to move
> > the hotplug/smp code out of mach directories if this approach is
> > accepted.

Thanks for doing the rework. This looks really good to me now.

I'd gotten myself confused while reading the bindings, but having now
had a look over the dts files my concerns were invalid.

Hopefully we can move more platforms to use enable-methods now :)

Cheers,
Mark.
