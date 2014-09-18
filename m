Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaIRJzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:55:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:18480 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbaIRJzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:55:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="593161439"
Date: Thu, 18 Sep 2014 12:55:05 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Loic Poulain <loic.poulain@intel.com>, linus.walleij@linaro.org,
        heikki.krogerus@linux.intel.com, mathias.nyman@linux.intel.com,
        linux-kernel@vger.kernel.org, Eric Ernst <eric.ernst@linux.intel.com>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
Message-ID: <20140918095505.GI10854@lahna.fi.intel.com>
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
 <20140918074910.GC10854@lahna.fi.intel.com>
 <20140918094113.GC26004@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918094113.GC26004@zurbaran>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:41:13AM +0200, Samuel Ortiz wrote:
> Hi Mika,
> 
> On Thu, Sep 18, 2014 at 10:49:43AM +0300, Mika Westerberg wrote:
> > On Wed, Sep 17, 2014 at 03:47:01PM +0200, Loic Poulain wrote:
> > > Direct Irq En bit can be initialized to a bad value.
> > > This bit has to be cleared for io access mode.
> > 
> > +Eric
> > 
> > I would like to have a bit better explanation *why* this bit needs to be
> > cleared.
> > 
> > Also want to ask Eric (who added the WARN()), is there something
> > preventing us to do this? I remember last time you said that we are not
> > supposed to change this bit runtime.
> > 
> > My preference is that we get rid of the WARN() and just unconditionally
> > clear the bit.
> I'd keep the warn though, as it most likely shows a buggy firmware
> implementation.

Fair enough :)

Maybe it could be more informative.
