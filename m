Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaGLQms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:42:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaGLQmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:42:46 -0400
Date: Sat, 12 Jul 2014 09:47:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Jiri Slaby <jslaby@suse.cz>,
        julia.lawall@lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: tty: Merge alloc_tty_struct and
 initialize_tty_struct
Message-ID: <20140712164714.GA12148@kroah.com>
References: <1405018882-19073-1-git-send-email-linux@rasmusvillemoes.dk>
 <1405162551-23308-1-git-send-email-linux@rasmusvillemoes.dk>
 <20140712121613.GY23001@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140712121613.GY23001@mwanda>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 03:16:13PM +0300, Dan Carpenter wrote:
> On Sat, Jul 12, 2014 at 12:55:51PM +0200, Rasmus Villemoes wrote:
> > The two functions alloc_tty_struct and initialize_tty_struct are
> > always called together. Merge them into alloc_tty_struct, updating its
> > prototype and the only two callers of these functions.
> > 
> > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > ---
> > I hope this is sufficient. Thanks, Dan and Julia!
> 
> Generally Greg's trees can't be rebased.  I think you need to send a fix
> patch.

That is correct.  Rasmus, please just send a patch on top of my tree
that resolves this issue.

thanks,

greg k-h
