Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3B0Fbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:31:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:30413 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3B0Fbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:31:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,746,1355126400"; 
   d="scan'208";a="292357737"
Date: Wed, 27 Feb 2013 11:01:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, herbert@gondor.hengli.com.au,
        dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: crypto: omap-sham, omap-aes and
 dma_request_slave_channel_compat()
Message-ID: <20130227053109.GA28537@intel.com>
References: <512D00BE.8090204@canonical.com>
 <20130226225205.GA13338@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130226225205.GA13338@animalcreek.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 03:52:05PM -0700, Mark A. Greer wrote:
> [CC'ing more people & lists.]
> 
> On Tue, Feb 26, 2013 at 11:36:46AM -0700, Tim Gardner wrote:
> > Whats up with commits 0e87e73f4abe1ada69cf780fe2550c6361a1b53b and
> > b4b87a934c30fb91cbdd18ae028acdc361e1cf0f. As far as I can tell,
> > dma_request_slave_channel_compat() does not exist in 3.9 as of
> > 52caa59ed335616c5254adff7911465a57ed9f14, nor does it exist in
> > linux-next as of Feb 26. Am I just being dense ?
> 
> Yeah, order got a little messed up.  The problem is known and the
> sub-thread talking about it starts about here:
> 
> 	http://www.spinics.net/lists/arm-kernel/msg225241.html
> 
> with the conclusion (AFAICT) that Vinod is to push it:
> 
> 	http://www.spinics.net/lists/arm-kernel/msg226062.html
> 
> > Reverting those 2 commits at least allows the compile complete.
> 
> When the dependencies are sorted out, will you revert the revert
> or do I need to do something?
Yes we had agreed that I will send it.

I have applied this one now, and will send second PULL request to Linus soon.

Arnd,
The second patch of dw_dmac you wnated to send me fails to apply for me. Can you
either rebase or send with your updates with my ack?

Either ways let me know
--
~Vinod
