Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaEaUSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:18:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaEaUSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:18:36 -0400
Date: Sat, 31 May 2014 13:18:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair Rzayev <tair.rzayev@gmail.com>
Cc: swetland@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: binder.c: Use more appropriate
 functions for euid retrieval
Message-ID: <20140531201834.GA3082@kroah.com>
References: <538A30E6.6010403@gmail.com>
 <20140531195205.GA14077@kroah.com>
 <538A35A0.1080006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538A35A0.1080006@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 11:03:44PM +0300, Tair Rzayev wrote:
> 
> 
> On 2014.05.31. 22:52, Greg KH wrote:
> > What kernel tree did you make this against?  It doesn't seem to match up
> > with what is in my staging-next branch to merge with Linus for the next
> > release, so please work against that one.
> 
> Made against staging-next branch of your linux-next staging tree.

Hm, it doesn't apply there:

checking file drivers/staging/android/binder.c
Reversed (or previously applied) patch detected!  Assume -R? [n]
Apply anyway? [n]
Skipping patch.
4 out of 4 hunks ignored

Are you sure you got the right branch?

> > Oh, and I think this is already been done, although in a bit different
> > way there, please check to make sure it is correct.
> 
> Yes, I have noticed the changes after I have made the patch but I
> thought mine are a bit cleaner so I have rebased the patch against the
> changes that are already applied.

Something went wrong when you made this :(

Care to try again?

thanks,

greg k-h
