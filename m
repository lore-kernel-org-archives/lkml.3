Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3CTUlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:41:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754455Ab3CTUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:41:22 -0400
Date: Wed, 20 Mar 2013 16:41:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Sven Joachim <svenjoac@gmx.de>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI
 controllers
In-Reply-To: <20130320202816.GA18496@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1303201635230.1208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Mar 2013, Greg Kroah-Hartman wrote:

> > > Ok, I'll postpone this patch for the next stable release, in time for
> > > the fix to be put in at the same time.
> > 
> > I think patch 13/75 ("USB: EHCI: dont check DMA values in QH overlays")
> > should also be postponed then, at least Alan said so in
> > <Pine.LNX.4.44L0.1303191125100.15684-100000@netrider.rowland.org>.
> 
> Crap, I didn't postpone that one, hopefully it doesn't cause as many
> problems...

I haven't tested this combination of changes, except in a highly 
artificial setting (i.e., running the usbtest suite), so I don't know 
how it will behave under normal use.  In any case, it's too late to do 
anything now except issue another -stable release.

I just saw that the "dont check DMA values" patch did get into the
3.0-stable and 3.4-stable releases.  I didn't realize at the time, but
it shouldn't be in any kernel earlier than 3.6.  I guess the best thing
to do is queue up a reversion for those two series.

Alan Stern

