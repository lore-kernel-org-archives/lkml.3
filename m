Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3FQRhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3FQRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:37:39 -0400
Date: Mon, 17 Jun 2013 10:37:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130617173738.GA14921@kroah.com>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
 <20130617134741.GA15547@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617134741.GA15547@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 03:47:41PM +0200, Pavel Machek wrote:
> Hi!
> 
> > This adds ability to bind uio driver to given open firmware device
> > using command line option. Thus, userspace driver can be developed and
> > used without modifying the kernel.
> > 
> > Signed-off-by: Pavel Machek <pavel@denx.de> 
> 
> Ping? Greg, could you apply this patch? Or is there someone else I
> should ask to apply it?

Ugh, Hans seems to have dropped off of the net for a long time now, so I
guess I'll start queueing up UIO patches again.  Care to resend this?

thanks,

greg k-h
