Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaGLIFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 04:05:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaGLIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 04:05:01 -0400
Date: Sat, 12 Jul 2014 01:08:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, kernelnewbies@kernelnewbies.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712080857.GA17634@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712015327.GA26496@kroah.com>
 <1405130244.6751.32.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405130244.6751.32.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:57:24PM -0700, Joe Perches wrote:
> On Fri, 2014-07-11 at 18:53 -0700, Greg KH wrote:
> > On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > > A simple script to run checkpatch --fix for various types of
> > > of cleanups.
> []
> > Anyway, try running this script on
> > drivers/staging/lustre/lnet/lnet/acceptor.c to see how this build fails.
> 
> lustre doesn't use "normal" kernel makefiles.

Ok, I've fixed all of the lustre Makefile crud up and checked it into my
staging-next branch.  In doing so, it exposed just what a horrid mess
the lustre include files are, which is good, hopefully people will
notice and start fixing it up.

And with the fixes, this script now properly can build and test lustre
files.

thanks,

greg k-h
