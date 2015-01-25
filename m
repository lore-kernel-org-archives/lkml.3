Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbbAYWH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:07:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbAYWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:07:26 -0500
Date: Sun, 25 Jan 2015 14:07:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Esben Haabendal <esben.haabendal@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
Message-ID: <20150125220723.GD29924@kroah.com>
References: <1420472564.803.9.camel@gmail.com>
 <20150105154834.GV11764@sirena.org.uk>
 <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
 <20150123124529.GU21293@sirena.org.uk>
 <20150125173853.GA6467@kroah.com>
 <20150125201254.GX21293@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150125201254.GX21293@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 08:12:54PM +0000, Mark Brown wrote:
> On Sun, Jan 25, 2015 at 09:38:53AM -0800, Greg Kroah-Hartman wrote:
> > On Fri, Jan 23, 2015 at 12:45:29PM +0000, Mark Brown wrote:
> 
> > > So, I now see this has actually been merged into stable without getting
> > > to the bottom of why it's helping anything...  this is a bit worrying
> > > since it's adding new functionality and not really a bug fix.  It'd have
> > > been good to at least get a followup here.
> 
> > Do you want me to revert something from the stable tree?  If so, has it
> > also been reverted upstream?
> 
> The patch just isn't an obvious -stable patch - it's adding new
> functionality, not fixing a bug, and I was surprised to discover it had
> been added as a result.  It's fine as new functionality and therefore
> hasn't been reverted upstream.
> 
> We can probably leave it there, though if this is OK that's a bit of a
> change, but if this new functionality is a good fix then we're probably
> leaving other systems unfixed which isn't good, I would be very much
> happier if we understood what had changed here.  If new functionality is
> OK there's a probably a bunch of other changes we should be pulling
> back.

New functionality shouldn't be added, but sometimes things slip in due
to the volume of patches and how people word-smith changelog entries :(

greg k-h

