Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbaKFEpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:45:52 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50595 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKFEpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:45:50 -0500
Date: Thu, 6 Nov 2014 13:45:34 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Brown <broonie@kernel.org>, sameo@linux.intel.com,
        lee.jones@linaro.org, jg1.han@samsung.com, cooloney@gmail.com,
        lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141106044534.GB5068@jack-ThinkPad-T520>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <1415051139.20372.85.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415051139.20372.85.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 10:45:39PM +0100, Paul Bolle wrote:
> On Fri, 2014-10-31 at 16:44 +0000, Mark Brown wrote:
> > On Fri, Oct 31, 2014 at 04:08:41PM +0900, gyungoh@gmail.com wrote:
> > > From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > > 
> > > Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> > 
> > This doesn't apply against current code and depends on the MFD symbol
> > rename - can you please check what's going on here?
> > 
> > It would make sense to split the Kconfig symbol rename into a separate
> > patch to ease merging,
> 
> The relicensing (from GPL to GPL v2, thus dropping the "or later"
> provision) is odd too. The header still uses GPL v2 or later, doesn't
> it? Anyhow, that could be a separate patch too.

I will modify the licensing text and resubmit it.
Thank you for your comment.

> 
> > it doesn't seem obviously related to the driver
> > change and should probably be in the same patch as the MFD symbol rename
> > for bisetion.
> 
> I don't think there will be bisection problems (in mainline). Currently
> this driver depends on SKY81452. But that symbol doesn't exist. Only
> after both 1/8 and this patch will this driver become buildable, for the
> first time. So it's not that this driver was buildable, became
> unbuildable in 1/8 and buildable again in this patch.
> 
> (I don't think it's much of a problem that the regulator driver got
> merged, in v3.18-rc1, before the mfd driver on which it depends.
> Avoiding that temporarily problem appears to be more trouble than it's
> worth.)
> 
> 
> Paul Bolle
> 
