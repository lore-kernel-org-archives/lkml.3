Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaBSOdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:33:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaBSOdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:33:06 -0500
Date: Wed, 19 Feb 2014 06:35:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next 01/11 RESEND] mei: add mei_hbuf_acquire wrapper
Message-ID: <20140219143539.GB31063@kroah.com>
References: <1392642807-8878-1-git-send-email-tomas.winkler@intel.com>
 <1392642807-8878-2-git-send-email-tomas.winkler@intel.com>
 <20140218180357.GA15274@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B1AF74203@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AF74203@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 09:58:08AM +0000, Winkler, Tomas wrote:
> 
> > 
> > This patch fails to apply to my char-misc-next branch (I've pulled in
> > 3.14-rc3 into this branch now):
> > 	checking file drivers/misc/mei/amthif.c
> > 	checking file drivers/misc/mei/client.c
> > 	Hunk #4 FAILED at 681.
> > 	Hunk #5 succeeded at 815 (offset -2 lines).
> > 	Hunk #6 succeeded at 848 (offset -2 lines).
> > 	1 out of 6 hunks FAILED
> > 	checking file drivers/misc/mei/hw-me.c
> > 	checking file drivers/misc/mei/hw-txe.c
> > 	checking file drivers/misc/mei/interrupt.c
> > 	checking file drivers/misc/mei/mei_dev.h
> > 	checking file drivers/misc/mei/wd.c
> > 
> > Care to fix this up and resend this series?
> 
> 
> The patch 'mei: set client's read_cb to NULL when flow control fails'
> (accb884b32e82f943340688c9cd30290531e73e0) Which is in
> char-misc-linus, still haven't make it to the  upstream...I thought it
> would be in rc3 already.

No, you sent it too late for that.

> I can either fix the current series and then you will need to resolve
> quite simple conflict in merge (it's just a two line patch) or we wait
> for another cycle.  I would prefer the first option as I have few more
> patches in the queue I won't to send for review but it's up to you.

I'll merge char-misc-linus into char-misc-next and then can you resend
the pending patches to me?

thanks,

greg k-h
