Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbaAKWwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 17:52:35 -0500
Received: from netrider.rowland.org ([192.131.102.5]:52931 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750800AbaAKWwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 17:52:31 -0500
Date: Sat, 11 Jan 2014 17:52:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@linuxfoundation.org>
cc: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <JBottomley@parallels.com>, <bhelgaas@google.com>
Subject: Re: [PATCHSET v2 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
In-Reply-To: <20140111201909.GA30380@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1401111751040.16586-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014, Greg KH wrote:

> On Sat, Jan 11, 2014 at 01:51:10PM -0500, Tejun Heo wrote:
> > Hey, Alan.
> > 
> > On Fri, Jan 10, 2014 at 10:46:10AM -0500, Alan Stern wrote:
> > > The SUBJECT lines in your patch emails don't mention the version
> > > number.  That is, they just say "[PATCH]", not "[PATCH v2]" or "[PATCH
> > > v3]". This makes it very difficult for me to tell which messages to
> > > read.
> > 
> > Hmm... they're all threaded.  I add version tags when posting
> > incremental patches but usually don't bother with it when posting a
> > new version of the whole series.  After all, some patches are get
> > updated without explicitly given a new version for refrehses and stuff
> > so it's not like you can determine everything based on subjects only.

Greg, what do you prefer in this situation?

> > > (Reading them in order doesn't work, because my computer mixes up the 
> > > order of messages when it downloads a large bunch from the email 
> > > server.  It's kind of annoying...)
> > 
> > And they aren't threaded?
> 
> They were all threaded for me, perhaps Alan needs a better email client :)

Undoubtedly I do.  My current client is embarassingly old.

Alan Stern

