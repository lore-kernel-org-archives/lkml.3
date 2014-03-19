Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbaCSVpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:45:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53086 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaCSVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:45:29 -0400
Date: Wed, 19 Mar 2014 21:45:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: Re: [PATCH] mfd: as3722: make FUSE7_REG readable
Message-ID: <20140319214524.GB20260@lee--X1>
References: <1393951832-2638-1-git-send-email-swarren@wwwdotorg.org>
 <20140305015539.GK10579@lee--X1>
 <5329C133.60900@wwwdotorg.org>
 <20140319170138.GK31687@lee--X1>
 <20140319170437.GA18095@lee--X1>
 <5329D037.4030008@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5329D037.4030008@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> From: Stephen Warren <swarren@nvidia.com>
> >>>>>
> >>>>> The FUSE7_REG register is not currently marked readable. This causes
> >>>>> as3722_sd0_is_low_voltage() to emit an error during boot, and assume
> >>>>> the range of the SD0 regulator:
> >>>>>
> >>>>> as3722-regulator as3722-regulator: Reg 0xa7 read failed: -5
> ...
> >>>> Applied to MFD -next (v3.15).
> >>>
> >>> I don't see this in next-20140319; did it get dropped somewhere, or was
> >>> your branch not pushed out?
> >>
> >> Ah, thanks for the reminder.
> >>
> >> I moved the MFD tree from linaro.org to kernel.org, but failed to let
> >> Stephen know. I'll do so now.
> > 
> > Whoops. No, you're Stephen. I meant Andrew.
> 
> I think you did mean Stephen (Rothwell) :-)

I do.

That's who I emailed, but I didn't want to correct myself twice. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
