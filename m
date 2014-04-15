Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaDOQ0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 12:26:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63202 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbaDOQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 12:26:10 -0400
Date: Tue, 15 Apr 2014 17:26:21 +0100
From: Will Deacon <will.deacon@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, Harini Katakam <harinik@xilinx.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Simek <michals@xilinx.com>
Subject: Re: [PATCH] spi: cadence: Add dependency on ARCH_ZYNQ
Message-ID: <20140415162621.GO17408@arm.com>
References: <1397537392-3709-1-git-send-email-harinik@xilinx.com>
 <CAHTX3dJrMxWJ-8i-wLRkQYtR_zbA+nJyGW+r-DFMYHHU4Erzbw@mail.gmail.com>
 <20140415094541.GL12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415094541.GL12304@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:45:41AM +0100, Mark Brown wrote:
> On Tue, Apr 15, 2014 at 08:11:37AM +0200, Michal Simek wrote:
> 
> > I sent the patch for it which solve this problem in generic way.
> > http://lkml.org/lkml/2014/4/8/42
> 
> > Feel free to give me ACK for it.
> 
> Will has been working on this too off and on, he was also trying to
> define some semantics for the relaxed versions.  It'd be really good to
> address this properly, this is a constant source of make work.

Yes, I have a series adding relaxed accessors to all architectures (and
asm-generic) along with an attempt at defining some semantics. This came
about from discussion with BenH at the last kernel summit, I just didn't get
around to posting what we came up with.

I should be able to post something this week, but there's still an open
question relating to mmiowb() that I'd like the PPC guys to chime in on.

Will
