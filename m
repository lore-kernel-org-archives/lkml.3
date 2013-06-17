Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3FQXxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:53:04 -0400
Received: from etezian.org ([198.101.225.253]:46092 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab3FQXxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:53:03 -0400
Date: Tue, 18 Jun 2013 01:54:26 +0200
From: Andi Shyti <andi@etezian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Shyti <andi@etezian.org>, arnd@arndb.de, linux-kernel@vger.kernel.org,
        pc@asdf.org, oatilla@gmail.com
Subject: Re: [PATCH 01/19] bh1770glc: added input device interface
Message-ID: <20130617235426.GE4454@jack.whiskey>
References: <cover.1371145891.git.andi@etezian.org>
 <90a9ed312d038eda11648a6ed49bb968824bf875.1371145891.git.andi@etezian.org>
 <20130617225241.GB21613@kroah.com>
 <20130617232739.GA4454@jack.whiskey>
 <20130617233607.GC14084@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617233607.GC14084@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > The driver generates an event in /dev/input/ under the name
> > > > 'bh1770'. It's a switch event where is reported '0' or '1'
> > > > whenever the sensor detects something crossing the threshold.
> > > > 
> > > Doesn't this mean that this driver is now an "input" driver, so it
> > > shouldn't be using the odd sysfs api, and should move to the
> > > drivers/input/ directory tree?
> > 
> > The driver has also lots of interfaces in
> > sysfs that are used from userspace, like proximity value and
> > ambient light value.
> > 
> > What the input interface provides is just one of the features
> > from the driver. Shall I move it anyway?
> 
> Hm, why not make it an iio driver instead?  That way you get input and
> sysfs all together.

I'll do my best to get the hardware I need, then, so that once I
do it I'll do it fully correct :)

Then, just ignore this patches and I'll come later with a new
patchset.

But I still wonder: this is a combined proximity/ambient light
sensor, where exactly should I move it? Is it correct to create a
new directory for combined sensors?

Andi
