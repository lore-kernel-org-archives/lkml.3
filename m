Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3I3XxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:53:13 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53704 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3I3XxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:53:11 -0400
Date: Tue, 1 Oct 2013 08:53:06 +0900
From: Simon Horman <horms@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] ARM: shmobile: CPUFreq support on Lager
Message-ID: <20130930235306.GB13399@verge.net.au>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1309301719460.16868@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1309301719460.16868@axis700.grange>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Mon, Sep 30, 2013 at 05:25:42PM +0200, Guennadi Liakhovetski wrote:
> Hi Simon,
> 
> Just a quick check of the status of this patch series:
> 
> On Thu, 26 Sep 2013, Guennadi Liakhovetski wrote:
> 
> > On Lager a da9210 regulator is used to supply DVFS power to the SoC. This
> > patch series adds I2C and Z-clock support on r8a7790 and CPUFreq support
> > for the Lager board. Please note, that patch 4/4 is an RFC as explained
> > inline.
> > 
> > Developed on top of today's
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git    devel
> > 
> > plus i2c-rcar patches from my earlier patch series
> > 
> > [PATCH v2 0/5] i2c: rcar: Device Tree support and clock improvements
> > 
> > and the "sh-pfc: r8a7790: Add I2C pin groups and functions" patch from
> > Ulrich Hecht.
> > 
> > All changes since v1 are noted in respective patches. They all are trivial,
> > still as soon as test hardware is available, it would be good to run-time
> > test this version too.
> > 
> > Cc: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > 
> > Guennadi Liakhovetski (5):
> >   pinctrl: sh-pfc: r8a7790: add pin definitions for the I2C3 interface
> 
> Laurent has taken this one.
> 
> >   ARM: shmobile: r8a7790: add I2C clocks and aliases for the DT mode
> >   ARM: shmobile: r8a7790: add I2C DT nodes
> 
> You've applied the above two too, thanks.
> 
> >   ARM: shmobile: r8a7790: add CPUFreq clock support
> 
> Do I see it right, that you're waiting for a review for the above one?

Yes, sorry for not being clearer.
I would like a review of this.

> >   ARM: shmobile: lager: (DEVEL) add CPUFreq support
> 
> Once a review of #4/5 is posted, I can split the above patch into two to 
> separate shmobile and DT parts, as requested by Sergei. Is that about what 
> you're expecting too?

Again, sorry for not being clearer. Yes, I agree with Sergei.
I would like the patch split into a DT patch and a board patch.
