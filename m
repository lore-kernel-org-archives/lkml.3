Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab3DHQLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:11:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:32549 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934542Ab3DHQLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="224617719"
Date: Mon, 8 Apr 2013 18:11:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, wim@iguana.be,
        lgirdwood@gmail.com, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 0/12] Palmas updates
Message-ID: <20130408161124.GA7255@zurbaran>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <20130405163056.GN17363@zurbaran>
 <5162E88E.9010204@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5162E88E.9010204@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Graeme,

On Mon, Apr 08, 2013 at 04:55:58PM +0100, Graeme Gregory wrote:
> On 05/04/13 17:30, Samuel Ortiz wrote:
> > Hi Ian,
> >
> > On Fri, Mar 22, 2013 at 02:55:10PM +0000, Ian Lartey wrote:
> >> This patchset adds to the support for the Palmas series of PMIC chips.
> >>
> >> Some of the patches have previously been submitted individually.
> >> The DT bindings doc has been added first due to comments that it was missing.
> >>
> >> Patches based on linux-next-20130319
> > Are you expecting all those patches to go through the MFD tree ?
> > Also, you stil have a few comments from Milo and Stephen to adress. Are you
> > planning to send a v11 ?
> >
> >
> Hi Samuel,
> 
> The device is an MFD so I suspect the best path is through MFD tree
Yes, that's fine. I just need to make sure everyone is on sync.


> although I notice you have applied the patch that was required by all
> other patches so maybe this is not so much the case now!
> 
> Real life has got in the way of the next updated series of patches but
> they will be issued just as soon as we can.
I know about real life getting in the way, no worries ;)

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
