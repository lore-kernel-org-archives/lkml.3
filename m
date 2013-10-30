Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3J3NVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:21:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3J3NVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:21:44 -0400
Date: Wed, 30 Oct 2013 06:23:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
Message-ID: <20131030132343.GA30447@kroah.com>
References: <20131024100942.GA13614@kroah.com>
 <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
 <20131025104212.GA22369@kroah.com>
 <1382709644.8698.31.camel@oc7383187364.ibm.com>
 <20131025152146.GA27323@kroah.com>
 <1383131998.16560.106.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383131998.16560.106.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:19:58PM +0100, Frank Haverkamp wrote:
> Hi Greg,
> 
> Am Freitag, den 25.10.2013, 16:21 +0100 schrieb Greg KH:
> > On Fri, Oct 25, 2013 at 04:00:44PM +0200, Frank Haverkamp wrote:
> > > > And why are you doing debug stuff through the ioctl interface?  Please
> > > > move that to debugfs if you really want/need that information, it does
> > > > not belong in an ioctl.
> > > 
> > > I will look into that. We need that information per card when it fails.
> > 
> > People put per-card information in debugfs all the time, look at the USB
> > host controller files in debugfs for an example of how to do this.
> 
> Thanks for pointing me to the example. I moved some of my former sysfs
> interfaces to debugfs. Especially those which were printing out more
> than one item. I guess you don't like those in sysfs anyways.

It's forbidden, thanks for noticing and fixing that before I had to say
the same thing later...

greg k-h
