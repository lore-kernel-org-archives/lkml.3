Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3FQXz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:55:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab3FQXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:55:28 -0400
Date: Mon, 17 Jun 2013 16:55:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andi Shyti <andi@etezian.org>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, pc@asdf.org,
        oatilla@gmail.com
Subject: Re: [PATCH 01/19] bh1770glc: added input device interface
Message-ID: <20130617235527.GA18652@kroah.com>
References: <cover.1371145891.git.andi@etezian.org>
 <90a9ed312d038eda11648a6ed49bb968824bf875.1371145891.git.andi@etezian.org>
 <20130617225241.GB21613@kroah.com>
 <20130617232739.GA4454@jack.whiskey>
 <20130617233607.GC14084@kroah.com>
 <20130617235426.GE4454@jack.whiskey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617235426.GE4454@jack.whiskey>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 01:54:26AM +0200, Andi Shyti wrote:
> > > > > The driver generates an event in /dev/input/ under the name
> > > > > 'bh1770'. It's a switch event where is reported '0' or '1'
> > > > > whenever the sensor detects something crossing the threshold.
> > > > > 
> > > > Doesn't this mean that this driver is now an "input" driver, so it
> > > > shouldn't be using the odd sysfs api, and should move to the
> > > > drivers/input/ directory tree?
> > > 
> > > The driver has also lots of interfaces in
> > > sysfs that are used from userspace, like proximity value and
> > > ambient light value.
> > > 
> > > What the input interface provides is just one of the features
> > > from the driver. Shall I move it anyway?
> > 
> > Hm, why not make it an iio driver instead?  That way you get input and
> > sysfs all together.
> 
> I'll do my best to get the hardware I need, then, so that once I
> do it I'll do it fully correct :)
> 
> Then, just ignore this patches and I'll come later with a new
> patchset.
> 
> But I still wonder: this is a combined proximity/ambient light
> sensor, where exactly should I move it? Is it correct to create a
> new directory for combined sensors?

Ask the iio developers, they will know best here.

thanks,

greg k-h
