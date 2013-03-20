Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3CTW2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:28:48 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34762 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3CTW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:28:46 -0400
Date: Wed, 20 Mar 2013 15:28:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sven Joachim <svenjoac@gmx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI
 controllers
Message-ID: <20130320222844.GA9504@kroah.com>
References: <20130320202816.GA18496@kroah.com>
 <Pine.LNX.4.44L0.1303201635230.1208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1303201635230.1208-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:41:21PM -0400, Alan Stern wrote:
> On Wed, 20 Mar 2013, Greg Kroah-Hartman wrote:
> 
> > > > Ok, I'll postpone this patch for the next stable release, in time for
> > > > the fix to be put in at the same time.
> > > 
> > > I think patch 13/75 ("USB: EHCI: dont check DMA values in QH overlays")
> > > should also be postponed then, at least Alan said so in
> > > <Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>.
> > 
> > Crap, I didn't postpone that one, hopefully it doesn't cause as many
> > problems...
> 
> I haven't tested this combination of changes, except in a highly 
> artificial setting (i.e., running the usbtest suite), so I don't know 
> how it will behave under normal use.  In any case, it's too late to do 
> anything now except issue another -stable release.
> 
> I just saw that the "dont check DMA values" patch did get into the
> 3.0-stable and 3.4-stable releases.  I didn't realize at the time, but
> it shouldn't be in any kernel earlier than 3.6.  I guess the best thing
> to do is queue up a reversion for those two series.

I've now done this, thanks.

greg k-h
