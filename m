Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaKFEis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:38:48 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63932 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKFEip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:38:45 -0500
Date: Thu, 6 Nov 2014 13:38:29 +0900
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
Message-ID: <20141106043828.GA5068@jack-ThinkPad-T520>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <20141104004333.GA2965@jack-ThinkPad-T520>
 <20141104005329.GA3815@sirena.org.uk>
 <20141104054534.GA4108@jack-ThinkPad-T520>
 <20141104114120.GJ3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141104114120.GJ3815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 11:41:20AM +0000, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 02:45:34PM +0900, Gyungoh Yoo wrote:
> > On Tue, Nov 04, 2014 at 12:53:29AM +0000, Mark Brown wrote:
> 
> > > I'm having a hard time understanding why it is difficult to split the
> > > two changes - they are in completely separate files.
> 
> > I am sorry for the hard time.
> 
> > That was because the symbol changes had a dependency with 1/8.
> > In this case, Should Kconfig symbol change back from MFD_SKY81452
> > to SKY81452 in this patch series? And then should I submit to change to MFD_SKY81452
> > with seperate patch?
> 
> No, what I'm saying is that if you want to rename the Kconfig symbol you
> should do that as part of a separate patch to changing the DT stuff.

I see.
I will split this patch. One is for DT stuff and the other is for Kconfig
symbol rename.
Thank you for your comment.
