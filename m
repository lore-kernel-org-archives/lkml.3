Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbaEEWmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:42:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaEEWmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:42:40 -0400
Date: Mon, 5 May 2014 15:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Improve missing blank line after
 declarations test
Message-Id: <20140505154238.a7a6606b474ca2f3a5b59471@linux-foundation.org>
In-Reply-To: <1399329343.27516.2.camel@joe-AO725>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
	<20140429173221.GE26890@mwanda>
	<20140503234326.GA30117@kroah.com>
	<20140505095935.GO26890@mwanda>
	<1399319468.26330.2.camel@joe-AO725>
	<1399320736.26330.8.camel@joe-AO725>
	<20140505151531.af8e82be3a0c4800f0051de2@linux-foundation.org>
	<1399329343.27516.2.camel@joe-AO725>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2014 15:35:43 -0700 Joe Perches <joe@perches.com> wrote:

> > @@ -67,6 +68,7 @@ long vfs_truncate(struct path *path, lof
> >  {
> >  	struct inode *inode;
> >  	long error;
> > +	wobble();
> >  
> >  	inode = path->dentry->d_inode;
> 
> Patch content can be a bit odd when lines are
> both added and deleted so checkpatch bleats
> only when both lines are added.
> 
> +	int foo;
> +	wibble();
> 
> generates a complaint.
> 
>  	int foo;
> +	wibble_wobble();
> 
> does not.

Oh, OK.

I have seen no instances of this warning since adding the patch.  So I
guess it's safe to merge but perhaps insufficiently aggressive.  Or
maybe people are being well-behaved.

Oh well, I'll keep an eye out.
