Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3EBN7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:59:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51281 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751834Ab3EBN66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:58:58 -0400
Date: Thu, 2 May 2013 09:58:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: remove remaining instances of USB_SUSPEND
In-Reply-To: <CA+55aFyaQsOpJu=jkFmQyQrBNG7fyh8Vqy1eUCFKVug1s_P+QA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305011251510.929-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Linus Torvalds wrote:

> On Wed, May 1, 2013 at 9:13 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > This patch (as1677) removes the remaining instances of that symbol.
> 
> Btw, what are these "asXXXX" ID's, and what does the noise buy us?
> 
> Doing a
> 
>   git log | egrep -w 'as[0-9]{3,}'
> 
> shows that this has been going on forever, but it still doesn't make
> any *sense*. It adds nothing worthwhile. In fact, doing
> 
>   git log | grep 'This patch ('
> 
> shows that you're pretty the only one doing it, but there's *one*
> other one jidong xiao: jx001. I really don't see the advantage of
> having this kind of random noise in the kernel logs.

I put those indexes in the patch descriptions to help with my own file
organization.  Without them, the patch files are just a big mess of
stuff with more or less arbitrary names.  The indexes have no meaning
to anybody else.

Originally I put the indexes in the email subject lines.  Greg didn't 
like this, so at his request I moved them into the patch descriptions.

I suppose they could be moved below the tear line, so that they
wouldn't show up in the final commits but only in the email messages.  
That would retain most of their utility for me without bothering anyone
else.

Jidong Xiao put that label in his patch because he was imitating me.

Alan Stern

