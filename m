Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHQQtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 12:49:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaHQQta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 12:49:30 -0400
Date: Sun, 17 Aug 2014 09:48:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: rtl8192u: checkpatch: do not use C99 //
 comments
Message-ID: <20140817164853.GA28582@kroah.com>
References: <20140810042221.GA5124@kroah.com>
 <1407676510-16168-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407676510-16168-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 03:15:10PM +0200, Martin Kepplinger wrote:
> Use the common kernel coding style, so don't use C99 // comments
> in r8192U_core.c If too long, where reasonable, they are shortened
> as well.
> 
> Some old internal comments about date and author of changes are
> removed.
> 
> This provides a more consistent view and hopefully encourages to
> look at it.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> Yes, there were changes in the meantime. This applies to -next20140808
> and builds. thanks.

This still doesn't apply, can you please refresh it again against the
next -next tree?

thanks,

greg k-h
