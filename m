Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3JVXrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 19:47:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab3JVXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 19:47:09 -0400
Date: Wed, 23 Oct 2013 00:48:35 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Message-ID: <20131022234835.GB12031@kroah.com>
References: <5265C0C5.70905@linux.intel.com>
 <20131022054406.GA14163@kroah.com>
 <20131022171400.GA14558@roeck-us.net>
 <20131022185004.GC53231@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131022185004.GC53231@bingao-desk1.fm.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 11:50:04AM -0700, Bin Gao wrote:
> On Tue, Oct 22, 2013 at 10:14:00AM -0700, Guenter Roeck wrote:
> > > 
> > > You can already do this today for PCI with the UIO framework, right?
> > > Why duplicate that functionality here with another userapce API that we
> > > will then have to maintain for the next 40+ years?
> > > 
> > Same for i2c, where the same functionality is supported through i2c-tools and
> > the i2c-dev driver. Adding i2c-tools to initramfs and/or to the root file system
> > should not be that much of an issue, much less than having to maintain two APIs
> > for the same purpose.
> > 
> > Guenter
> 
> For PCI and memory mapped I/O devices, we have the runtime pm issue that has to
> be addressed from kernel space.

Then create a UIO pci driver and you should be fine, right?  That's what
others do today and it works quite well for them.

greg k-h
