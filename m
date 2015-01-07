Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbbAGP6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:58:01 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:56865 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbbAGP57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:57:59 -0500
Date: Wed, 7 Jan 2015 15:57:47 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        khilman@linaro.org, daniel.lezcano@linaro.org
Subject: Re: [PATCH] ARM: vexpress: bindings: Add generic PD awareness to the
 spc controller
Message-ID: <20150107155747.GA31975@red-moon>
References: <1420562732-4353-1-git-send-email-mathieu.poirier@linaro.org>
 <CAL_JsqJwauxNNojhAaYEr7oQTm6fwYwtByv_s6-tHiXYA214AQ@mail.gmail.com>
 <CANLsYkz_tx0MAnssO1JmgGzeaj12oU64FJjiKKyEOyXuUKk8jQ@mail.gmail.com>
 <CAL_JsqLv8Q4eS_bwuLbEOBSxjU7uff4__KcSi3qwAvgmjhQKHw@mail.gmail.com>
 <20150107105438.GA7256@e102568-lin.cambridge.arm.com>
 <CANLsYkxbMT1cYquZzbcYuo+=5xNBUhS6jJePovErwkaDDef_Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLsYkxbMT1cYquZzbcYuo+=5xNBUhS6jJePovErwkaDDef_Gg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 02:33:38PM +0000, Mathieu Poirier wrote:

[...]

> >> > I will ask the vexpress maintainers where they want to see this code
> >> > going.  Would you accept this binding as part of the existing
> >> > "arm,vexpress-sysreg" [1] or even "arm,vexpress-scc" [2]?
> >
> > We are not CC'ed :). [2] is my answer, see below.
> 
> Thanks for the review - does it also mean you'd like to see the
> creation of the generic power domains moved to tc2_pm.c ?

Not necessarily, I think the creation is ok where it is, what we have
to do is to link the power domains to idle states instead of "disabling"
the spc power down command, see other thread.

I agree you need updated DT bindings for idle states to achieve that
and all the glue code that goes with it (in order for an idle state
to link to the power domain structs you are creating).

I copied in Kevin and Daniel since I know they are interested and are
working on this.

Thanks,
Lorenzo
