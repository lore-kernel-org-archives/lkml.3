Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbbAYRjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 12:39:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbbAYRi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 12:38:59 -0500
Date: Sun, 25 Jan 2015 09:38:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Esben Haabendal <esben.haabendal@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
Message-ID: <20150125173853.GA6467@kroah.com>
References: <1420472564.803.9.camel@gmail.com>
 <20150105154834.GV11764@sirena.org.uk>
 <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
 <20150123124529.GU21293@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123124529.GU21293@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 12:45:29PM +0000, Mark Brown wrote:
> On Tue, Jan 06, 2015 at 10:15:47PM +0100, Esben Haabendal wrote:
> > On 5 January 2015 at 16:48, Mark Brown <broonie@kernel.org> wrote:
> 
> > >> Please consider commit 4302a59629f7a0bd70fd1605d2b558597517372a
> > >> (spi: fsl: Fix problem with multi message transfers) for inclusion in
> > >> stable kernel 3.14.
> 
> > >> It fixes a regression when using mmc_spi driver on top of spi-fsl-spi
> > >> driver (tested with powerpc mpc8313 based board).
> 
> > > Has this ever worked?
> 
> > Yes, I have used mmc_spi with spi-fsl-spi on the same board with success
> > with in 2.6.33, 3.0 and 3.4.
> 
> > I have no idea what has caused this to break.  Maybe mmc_spi driver was
> > not doing multi message transfers earlier?
> 
> So, I now see this has actually been merged into stable without getting
> to the bottom of why it's helping anything...  this is a bit worrying
> since it's adding new functionality and not really a bug fix.  It'd have
> been good to at least get a followup here.

Do you want me to revert something from the stable tree?  If so, has it
also been reverted upstream?

confused,

greg k-h
