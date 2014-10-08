Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaJHErh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 00:47:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaJHErf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 00:47:35 -0400
Date: Tue, 7 Oct 2014 21:46:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] ring-buffer: Fix infinite spin in reading buffer
Message-ID: <20141008044636.GB26820@kroah.com>
References: <20141003162043.6817a486@gandalf.local.home>
 <20141005234943.GB23078@kroah.com>
 <20141007214011.158a7b2e@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007214011.158a7b2e@as>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:40:11PM -0500, Chuck Ebbert wrote:
> On Sun, 5 Oct 2014 16:49:43 -0700
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Oct 03, 2014 at 04:20:43PM -0400, Steven Rostedt wrote:
> 
> ...
> 
> > >     Fixes: 651e22f2701b "ring-buffer: Always reset iterator to reader page"
> > >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > Next time, please also add a Cc: stable...  here so that my tools pick
> > it up automatically.
> > 
> 
> Can you add "Fixes:" to the list of keywords your tools pick up, and
> determine if the patch is needed in -stable by looking at the commit ID
> that's being fixed? Some authors might not remember if the thing being
> fixed has made it into an older release via -stable.

I do that as well, but I don't advertise it as much, as it's easier for
me with the cc: stable marking :)

thanks,

greg k-h
