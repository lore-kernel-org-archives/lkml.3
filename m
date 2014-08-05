Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaHEEcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:32:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaHEEcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:32:13 -0400
Date: Mon, 4 Aug 2014 21:31:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Mohr <andi@lisas.de>
Cc: Kristina =?utf-8?Q?Mart=C5=A1enko?= 
	<kristina.martsenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [GIT PULL] Staging driver patches for 3.17-rc1
Message-ID: <20140805043143.GA31519@kroah.com>
References: <20140804190837.GA27292@kroah.com>
 <20140805041325.GA27507@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805041325.GA27507@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 06:13:25AM +0200, Andreas Mohr wrote:
> > Lots of things in here, over 2000 patches, but the best part is this:
> >  1480 files changed, 39070 insertions(+), 254659 deletions(-)
> >
> > Thanks to the great work of Kristina Martšenko, 14 different staging
> > drivers have been removed from the tree as they were obsolete and no
> > one
> > was willing to work on cleaning them up.
> 
> -ENOPARSE.
> 
> Define "as they were obsolete and no one was willing to work on cleaning
> them up."?
> 
> *Either* they're obsolete (due to better alternatives available, in the
> standard case), in which case they indeed can be removed on the spot,
> *or* they are expected to become full-service drivers and thus need cleanup.
> Which is it?

No one was willing to do the work to get these drivers out of the
staging directory.  One had been broken for a number of kernel releases
with no one even noticing.

> In the case of keucr (a driver where I happen to own hardware,
> and where AFAIK this driver is required),
> I really don't see "nobody was willing to work on cleaning them up.",
> as git log tells.

Don't confuse "coding style cleanups done in a drive-by fashion" with
"willing to do the real work to get this driver merged out of the
staging tree."

> Admittedly there probably was no substantial rework,
> but it did have many janitorial changes, and some changes
> only 4 months ago even (a time frame which IMHO does not justify
> removing a driver wholesale, with the effect of certain users to not
> be able to use them then).
> 
> Oh well, yet another driver where it became more difficult rather than
> easier to make forward progress.

If you are willing to do the work, I will gladly revert the patch and
look forward to patches to fix the remaining changes.

thanks,

greg k-h
