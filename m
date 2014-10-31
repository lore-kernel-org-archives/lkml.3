Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbaJaNzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:55:42 -0400
Received: from down.free-electrons.com ([37.187.137.238]:42804 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758871AbaJaNzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:55:40 -0400
Date: Fri, 31 Oct 2014 14:55:35 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Chen <peter.chen@freescale.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        gregkh@linuxfoundation.org, kishon@ti.com, stern@rowland.harvard.edu,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141031135535.GB11522@kwain>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
 <20141030163513.GI10130@saruman>
 <20141030174254.GA6764@kwain>
 <20141030174734.GA6652@saruman>
 <20141031003812.GA3692@peterchendt>
 <20141031004710.GA17652@saruman>
 <20141031133319.GC1273@saruman>
 <20141031134751.GE1273@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141031134751.GE1273@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, Oct 31, 2014 at 08:47:51AM -0500, Felipe Balbi wrote:
> On Fri, Oct 31, 2014 at 08:33:19AM -0500, Felipe Balbi wrote:
> > > > > > > > > Before using the PHY framework instead of the USB PHY one, we need to
> > > > > > > > > move the OTG state into another place, since it won't be available when
> > > > > > > > > USB PHY isn't used. This patch moves the OTG state into the OTG
> > > > > > > > > structure, and makes all the needed modifications in the drivers
> > > > > > > > > using the OTG state.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > > > > > > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > > > > > > > 
> > > > > > > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > > > > > 
> > > > > > > Please rebase on my testing/next and I'll take the series. When
> > > > > > > rebasing, then add Peter's Tested-by/Acked-by where they're missing.
> > > > > > 
> > > > > > I just re-sent the series, rebased on your testing/next branch.
> > > > > 
> > > > > Thanks, I put them on my testing/next and I'm running build tests.
> > > > > 
> > > > 
> > > > I see them, I will rebase your testing/next tree for coming chipidea dev, thanks.
> > > 
> > > I fixed a build breakage caused by $subject which I fixed, updated patch
> > > below: (Aaro, can I get a tested-by by any chance ?)
> > 
> > two more build regressions found (did you build test your patches ??)
> 
> and yet another one on phy-isp1301-omap.c. Seriously, if I find another
> build regression I'll drop your series from my queue and defer it to
> 3.20. This is ridiculous already.

Sorry for the inconvenience, the series modify quite a lot of files and
testing all of them is quite difficult. If you'd like I can fully test
it and send a new version early next week.

Deferring it to 3.20 will not solve the issue and will raise the same
errors as these build failures. The series has been sent for quite a
long time now, without having any comments on the latests revisions and
was therefore delayed. Each time it is delayed, it makes it more
difficult to ensure everything is working fine because of all the
modifications done in this subsystem... I tried to keep it up with all
the other patches introduced between my revisions, but this is not as
easy as it sounds.

Again, sorry for these failures, I can send to you a new version early
next week so that no other patches comes in between, breaking the
build...


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
