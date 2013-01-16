Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682Ab3APHzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:55:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:37992 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258Ab3APHzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:55:18 -0500
Date: Tue, 15 Jan 2013 23:56:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Fix ptmx open without closed slave.
Message-ID: <20130116075617.GB30679@kroah.com>
References: <50D20EB5.30900@ilyx.ru>
 <20130116070402.GA2527@kroah.com>
 <50F65B56.8090001@ilyx.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F65B56.8090001@ilyx.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:48:38AM +0400, Ilya Zykov wrote:
> 
> > 
> > Ok, I have a ton of patches from you, lots of different threads, patches
> > with the same subject, and I don't know what one Alan agreed to.
> > 
> > So, can you please resend what Alan and you agree should be applied to
> > the tree?
> > 
> 
> 
> I think only two important:
> [PATCH v4] tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
> 
> [PATCH] tty: Correct tty buffer flush.
> With Alan's ACK from 04.12.2012 for kernel <= 3.7
> 
> But for kernel 3.8 I resent this 05.12.2012
> [PATCH -next 0/2] tty: Correct tty buffer flush.
> [PATCH -next 1/2] tty: Correct tty buffer flush.
> [PATCH -next 2/2] tty: Correct tty buffer flush.
> The last I resent with new description after Jiri's remark.

How can you have more than one patch with the same subject?  Please
resend all patches that you wish to see applied, with proper Subject:
lines and acks, if you have gotten them.

thanks,

greg k-h
