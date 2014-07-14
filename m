Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaGNM7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:59:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaGNM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:58:57 -0400
Date: Mon, 14 Jul 2014 05:58:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: devel@driverdev.osuosl.org, tvboxspy@gmail.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        forest@alittletooquiet.net
Subject: Re: [PATCH V2 1/4] staging: vt6556: Cleanup coding style issues
Message-ID: <20140714125836.GA6966@kroah.com>
References: <1405278681-3348-1-git-send-email-peter.senna@gmail.com>
 <20140713193647.GA31010@kroah.com>
 <20140714085932.GA2958@hp-peter.rsr.lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714085932.GA2958@hp-peter.rsr.lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:59:32AM +0200, Peter Senna Tschudin wrote:
> On Sun, Jul 13, 2014 at 12:36:47PM -0700, Greg KH wrote:
> > On Sun, Jul 13, 2014 at 09:11:18PM +0200, Peter Senna Tschudin wrote:
> > > This patch cleanup coding style issues reported by checkpatch.
> > > 
> > > Tested by compilation only.
> > > 
> > > Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> > > ---
> > > Cahnges from V1:
> > >  - Sent all patches in a series
> > 
> > Why did you forget the other thing that I asked you to change?
> > 
> > I can't take these as-is, sorry, please go back and re-read what I
> > wrote...
> 
> Actually I was trying to do what you asked me on this E-mail:
> 
> -- // --
> You just sent me 4 patches, all with the same subject (but at least 2 of
> them had the order in which to apply them in, which is nice.)
> 
> Please redo these such that they have a unique subject, and I can tell
> which order to apply them in, as I really have no idea about the second
> two.
> -- // --
> 
> I'm sending V3 as a single patch.

That's going to get rejected as well :(

You did put them in a nice order, but you had the same subject text for
each patch, which I told you not to do, right?

{sigh}

greg k-h
