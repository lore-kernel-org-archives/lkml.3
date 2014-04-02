Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbaDBUCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:02:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaDBUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:02:06 -0400
Date: Wed, 2 Apr 2014 13:04:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Insop Song <insop.song@gainspeed.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Staging driver patches for 3.15-rc1
Message-ID: <20140402200428.GE26966@kroah.com>
References: <20140401184817.GA21855@kroah.com>
 <1396427043.18431.20.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396427043.18431.20.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 10:24:03AM +0200, Paul Bolle wrote:
> On Tue, 2014-04-01 at 11:48 -0700, Greg KH wrote:
> > Staging driver pull request for 3.15-rc1
> > 
> > Here's the huge drivers/staging/ update for 3.15-rc1.
> > 
> > Loads of cleanup fixes, a few drivers removed, and some new ones added.
> > 
> > All have been in linux-next for a while.
> >
> >[...]
> >
> > Insop Song (1):
> >       staging: fpgaboot: Xilinx FPGA firmware download driver
> 
> This commit adds checks for CONFIG_B4860G100. Is a patch to add a
> Kconfig symbol B4860G100 perhaps queued somewhere?

Insop, I thought this config option was coming from some other place,
right?

> It also adds this Makefile line:
>     ccflags-$(CONFIG_GS_FPGA_DEBUG)    := -DDEBUG
> 
> But there's no Kconfig symbol GS_FGPA_DEBUG. On the other hand, the code
> involved doesn't seem to use either DEBUG or dev_dbg() so perhaps it
> isn't actually needed. (But note that the code does check for
> DEBUG_FPGA, which apparently has to be set manually.)

Odds are we can just drop this, patches gladly accepted :)

thanks,

greg k-h
