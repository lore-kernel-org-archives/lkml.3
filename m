Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbaBUQzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:55:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaBUQxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:53:54 -0500
Date: Fri, 21 Feb 2014 08:56:33 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Michal Simek <monstr@monstr.eu>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>,
        devicetree@vger.kernel.org, Wolfgang Denk <wd@denx.de>
Subject: Re: SPDX-License-Identifier
Message-ID: <20140221165633.GA5465@kroah.com>
References: <774153d4-d33f-4bb4-813b-582762bc3af9@TX2EHSMHS021.ehs.local>
 <20140220182257.GF23217@saruman.home>
 <5306F458.9010706@monstr.eu>
 <20140221160442.GA17506@kroah.com>
 <5307790A.4050806@monstr.eu>
 <20140221161246.GM31902@saruman.home>
 <53077C5F.9000407@monstr.eu>
 <20140221162045.GN31902@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221162045.GN31902@saruman.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 10:20:45AM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Feb 21, 2014 at 05:18:39PM +0100, Michal Simek wrote:
> > On 02/21/2014 05:12 PM, Felipe Balbi wrote:
> > > On Fri, Feb 21, 2014 at 05:04:26PM +0100, Michal Simek wrote:
> > >> On 02/21/2014 05:04 PM, Greg Kroah-Hartman wrote:
> > >>> On Fri, Feb 21, 2014 at 07:38:16AM +0100, Michal Simek wrote:
> > >>>> BTW: u-boot started to use SPDX-License-Identifier
> > >>>> which will be nice to start to use.
> > >>>
> > >>> I agree, feel free to start sending patches to use this type of
> > >>> identifier for drivers.
> > >>
> > >> But we probably need to add that Licenses to one location.
> > >> Documentation/Licenses?
> > > 
> > > Just add to the drivers themselves, just like u-boot is doing. A simple:
> > > 
> > > 	$ git grep -e SPDX-License-Identifier
> > > 
> > > will tell you filename and license. Or did I misunderstand your question ?
> > 
> > But for doing this it is probably necessary to have location where
> > you will place that licenses and you will explain what it is how
> > it is done by Wolfgang in this commit.
> > 
> > http://git.denx.de/?p=u-boot.git;a=commitdiff;h=eca3aeb352c964bdb28b8e191d6326370245e03f
> > 
> > Then yes, adding one line is enough.
> 
> spdx.org has all licenses, why don't we just rely on that instead of
> adding every other license to the kernel source ?

Yes, all that will be acceptable is a one-line identifier in the file.
No need to have all the different licenses in the kernel source, that's
crazy and not needed at all.

I've told the SPDX people this in the past, and they keep promising that
they will do the comment work, but it's been months and I have yet to
see a single patch...

greg k-h
