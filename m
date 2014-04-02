Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161077AbaDBXWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:22:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030684AbaDBXWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:22:16 -0400
Date: Wed, 2 Apr 2014 16:08:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Insop Song <Insop.Song@gainspeed.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'insop.song@gmail.com'" <insop.song@gmail.com>
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
Message-ID: <20140402230837.GA24324@kroah.com>
References: <20140401184817.GA21855@kroah.com>
 <1396427043.18431.20.camel@x220>
 <20140402200428.GE26966@kroah.com>
 <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 08:52:18PM +0000, Insop Song wrote:
> On Wed, April 02, 2014 1:04 PM, Greg KH wrote:
> > On Wed, Apr 02, 2014 at 10:24:03AM +0200, Paul Bolle wrote:
> > > On Tue, 2014-04-01 at 11:48 -0700, Greg KH wrote:
> > > > Staging driver pull request for 3.15-rc1
> > > >
> > > > Here's the huge drivers/staging/ update for 3.15-rc1.
> > > >
> > > > Loads of cleanup fixes, a few drivers removed, and some new ones
> > added.
> > > >
> > > > All have been in linux-next for a while.
> > > >
> > > >[...]
> > > >
> > > > Insop Song (1):
> > > >       staging: fpgaboot: Xilinx FPGA firmware download driver
> > >
> > > This commit adds checks for CONFIG_B4860G100. Is a patch to add a
> > > Kconfig symbol B4860G100 perhaps queued somewhere?
> > 
> > Insop, I thought this config option was coming from some other place, right?
> > 
> 
> Paul,
> I didn't include CONFIG_B4860G100 in Kconfig in original patch set,
> since programming FPGA method can vary in different system, and this
> was discussed during the review with Greg as well.
> 
> However, actual fpga programming method is well contained in io.c with
> ifdef-ed CONFIG_B4860G100, now I think I might better to update
> Kconfig to include CONFIG_B4860G100.
> 
> Greg, what do you think? Any harm to add custom board CONFIG* to
> staging Kconfig? Let me know.

Let's see what it would look like and we can go from there.

thanks,

greg k-h
