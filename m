Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab3FRR6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:58:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872Ab3FRR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:58:40 -0400
Date: Tue, 18 Jun 2013 10:58:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130618175839.GC8386@kroah.com>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
 <20130617134741.GA15547@amd.pavel.ucw.cz>
 <20130617173738.GA14921@kroah.com>
 <20130618130216.GB15122@amd.pavel.ucw.cz>
 <20130618143043.GC17361@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618143043.GC17361@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:30:43PM +0200, Pavel Machek wrote:
> On Tue 2013-06-18 15:02:16, Pavel Machek wrote:
> > On Mon 2013-06-17 10:37:38, Greg KH wrote:
> > > On Mon, Jun 17, 2013 at 03:47:41PM +0200, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > > This adds ability to bind uio driver to given open firmware device
> > > > > using command line option. Thus, userspace driver can be developed and
> > > > > used without modifying the kernel.
> > > > > 
> > > > > Signed-off-by: Pavel Machek <pavel@denx.de> 
> > > > 
> > > > Ping? Greg, could you apply this patch? Or is there someone else I
> > > > should ask to apply it?
> > > 
> > > Ugh, Hans seems to have dropped off of the net for a long time now, so I
> > > guess I'll start queueing up UIO patches again.  Care to resend this?
> > 
> > Here you go. It still applies to your -next tree.
> 
> And here's version that removes "const" that is no longer true. I
> missed the compile warning before. Sorry,
> 								Pavel
> 
> -(cut here)-

Please resend in a format that I don't have to edit by hand.

greg k-h
