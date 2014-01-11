Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751026AbaAKXhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 18:37:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaAKXhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 18:37:07 -0500
Date: Sat, 11 Jan 2014 15:37:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        JBottomley@parallels.com, bhelgaas@google.com
Subject: Re: [PATCHSET v2 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
Message-ID: <20140111233709.GA6819@kroah.com>
References: <20140111201909.GA30380@kroah.com>
 <Pine.LNX.4.44L0.1401111751040.16586-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401111751040.16586-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 05:52:30PM -0500, Alan Stern wrote:
> On Sat, 11 Jan 2014, Greg KH wrote:
> 
> > On Sat, Jan 11, 2014 at 01:51:10PM -0500, Tejun Heo wrote:
> > > Hey, Alan.
> > > 
> > > On Fri, Jan 10, 2014 at 10:46:10AM -0500, Alan Stern wrote:
> > > > The SUBJECT lines in your patch emails don't mention the version
> > > > number.  That is, they just say "[PATCH]", not "[PATCH v2]" or "[PATCH
> > > > v3]". This makes it very difficult for me to tell which messages to
> > > > read.
> > > 
> > > Hmm... they're all threaded.  I add version tags when posting
> > > incremental patches but usually don't bother with it when posting a
> > > new version of the whole series.  After all, some patches are get
> > > updated without explicitly given a new version for refrehses and stuff
> > > so it's not like you can determine everything based on subjects only.
> 
> Greg, what do you prefer in this situation?

If the threading is correct, just as Tejun did is the best and easiest
for me to handle, as I can just delete the whole set of old patches and
use the new ones.

> > > > (Reading them in order doesn't work, because my computer mixes up the 
> > > > order of messages when it downloads a large bunch from the email 
> > > > server.  It's kind of annoying...)
> > > 
> > > And they aren't threaded?
> > 
> > They were all threaded for me, perhaps Alan needs a better email client :)
> 
> Undoubtedly I do.  My current client is embarassingly old.

There's nothing wrong with using old mail clients, mutt is very old, it
just works really well.

greg k-h
