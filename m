Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaGLTYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:24:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaGLTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:24:17 -0400
Date: Sat, 12 Jul 2014 12:28:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, kernelnewbies@kernelnewbies.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712192846.GB25649@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013444.GA30368@kroah.com>
 <1405129216.6751.18.camel@joe-AO725>
 <20140712093043.GG25880@mwanda>
 <20140712175526.GA17077@kroah.com>
 <1405189777.9132.27.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405189777.9132.27.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 11:29:37AM -0700, Joe Perches wrote:
> On Sat, 2014-07-12 at 10:55 -0700, Greg KH wrote:
> > Yes, the warnings are all due to line-length, but Joe, you shouldn't add
> > a patch that causes more checkpatch warnings than before :)
> 
> Yeah, that was intentional though.
> 
> This script does a series of relatively discrete changes.
> 
> Lindent would more or less work, but it's _horrible_ at
> wrapping overlong lines and merges all types of changes
> together.

Oh I agree, I don't want to see Lindent, but maybe, if the patch adds
checkpatch warnings, it should be at least "flagged" as maybe a problem?

> > While I always want to see more developers get involved with kernel
> > development, there should be a minimum barrier to entry.  And that
> > barrier is the knowledge of the C language, and knowledge of how to edit
> > a text file, and use git.  This script takes that barrier away, for
> > whitespace cleanups, with not much real use overall.
> > 
> > So, I'll keep my local copy of this script now, just to have fun with at
> > times when I'm bored.  But I don't think it should be merged, as-is.
> 
> Dunno, I still think it's useful.

For you, and me, but the world?

Would you want to be on the receiving end of this patch script?  I
don't, and I'm willing to take almost any patch cleanup for staging
code.  I think that says something :)

> Maybe when you get new code, you might run it through a
> script like this before committing it.

I will keep it for me, like I said.

thanks,

greg k-h
