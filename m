Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbaFPRJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:09:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43720 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932308AbaFPRJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:09:38 -0400
Date: Mon, 16 Jun 2014 18:09:36 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Richard Fitzgerald <rf@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: arizona: Export function to control subsystem
	DVFS
Message-ID: <20140616170936.GC26741@opensource.wolfsonmicro.com>
References: <20140609150013.GA5229@opensource.wolfsonmicro.com> <20140609150226.GB5229@opensource.wolfsonmicro.com> <20140616164242.GB14323@lee--X1> <20140616164858.GI5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616164858.GI5099@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 05:48:58PM +0100, Mark Brown wrote:
> On Mon, Jun 16, 2014 at 05:42:42PM +0100, Lee Jones wrote:
> > On Mon, 09 Jun 2014, Richard Fitzgerald wrote:
> 
> > > +	if (arizona->subsys_max_rq != new_flags) {
> 
> > I don't really get this.  What's the point in passing the mask
> > parameter - I don't see it being used for anything in this routine? No
> > matter what is passed in you always just turn on the same regulator.
> 
> > What am I missing?
> 
> AFAICT it's a bunch of different independently selectable requests for
> the voltage to ramped with any one of them causing it to happen.
> 
> I did wonder why this wasn't just done by refcounting, that's the more
> normal pattern in the kernel, though I guess it's possible some of them
> need different ramps on different devices.

Currently this is not the case, although it is certainly not
unthinkable that it would occur in future devices.

Thanks,
Charles
