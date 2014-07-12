Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaGLCAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 22:00:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaGLCAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 22:00:52 -0400
Date: Fri, 11 Jul 2014 19:05:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org, LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712020520.GA18611@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
 <20140712013927.GA30781@kroah.com>
 <1405129612.6751.24.camel@joe-AO725>
 <20140712020114.GA12301@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712020114.GA12301@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 07:01:14PM -0700, Greg KH wrote:
> On Fri, Jul 11, 2014 at 06:46:52PM -0700, Joe Perches wrote:
> > On Fri, 2014-07-11 at 18:39 -0700, Greg KH wrote:
> > > On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > > > A simple script to run checkpatch --fix for various types of
> > > > of cleanups.
> > ]
> > > drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.
> > > file: <drivers/staging/lustre/include/linux/lnet/api.h> description: <update c90 comment style> types:<c99_comments>
> > > Useless use of greediness modifier '+' in regex; marked by <-- HERE in m/(^\+.*) {8,8}+ <-- HERE \t/ at ./scripts/checkpatch.pl line 2217.
> > []
> > > drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.
> > []
> > > Is that expected?
> > 
> > No, I haven't seen that.
> > 
> > Can you tell me what git tree you're working on?
> 
> My staging-next branch of staging.git on git.kernel.org
> 
> > Also, can you use the scripts/checkpatch from -next
> > tag next-20140711
> 
> that will take a bit to checkout, I'll do that afterward.
> 
> > My system has:
> > 
> > $ perl --version 
> > 
> > This is perl 5, version 18, subversion 2 (v5.18.2) built for i686-linux-gnu-thread-multi-64int
> > (with 41 registered patches, see perl -V for more detail)
> 
> I think this started showing up for me for perl 5.20.  Let me go
> checkout linux-next and see if that fixes anything or not...

Ok, with linux-next I get the same thing:

~/linux/tmp/linux-next $ ./scripts/checkpatch.pl -f --strict drivers/staging/lustre/include/linux/lnet/api.h --types=c99_comments
Useless use of greediness modifier '+' in regex; marked by <-- HERE in m/(^\+.*) {8,8}+ <-- HERE \t/ at ./scripts/checkpatch.pl line 2358.
total: 0 errors, 0 warnings, 0 checks, 220 lines checked

NOTE: Used message types: C99_COMMENTS

drivers/staging/lustre/include/linux/lnet/api.h has no obvious style problems and is ready for submission.


