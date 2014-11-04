Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaKDFpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 00:45:49 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52836 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaKDFpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 00:45:46 -0500
Date: Tue, 4 Nov 2014 14:45:34 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141104054534.GA4108@jack-ThinkPad-T520>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <20141104004333.GA2965@jack-ThinkPad-T520>
 <20141104005329.GA3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141104005329.GA3815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 12:53:29AM +0000, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 09:43:34AM +0900, Gyungoh Yoo wrote:
> > On Fri, Oct 31, 2014 at 04:44:18PM +0000, Mark Brown wrote:
> 
> > > This doesn't apply against current code and depends on the MFD symbol
> > > rename - can you please check what's going on here?
> 
> > Are you talking about 'sky81452-regulator'?
> > I am sorry I don't understand. Can you explain in more detail?
> 
> No, I mean the Kconfig change.
> 
> > > It would make sense to split the Kconfig symbol rename into a separate
> > > patch to ease merging, it doesn't seem obviously related to the driver
> > > change and should probably be in the same patch as the MFD symbol rename
> > > for bisetion.
> 
> > becuase the symbol in the modfied MFD does not match with the
> > merged regulator driver, it was hard to split the patch.
> 
> I'm having a hard time understanding why it is difficult to split the
> two changes - they are in completely separate files.

I am sorry for the hard time.

That was because the symbol changes had a dependency with 1/8.
In this case, Should Kconfig symbol change back from MFD_SKY81452
to SKY81452 in this patch series? And then should I submit to change to MFD_SKY81452
with seperate patch?
