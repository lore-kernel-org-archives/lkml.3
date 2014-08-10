Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaHJML0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaHJMLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:13 -0400
Date: Sat, 9 Aug 2014 21:22:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Kepplinger <martink@posteo.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: checkpatch: do not use C99 // comments
Message-ID: <20140810042221.GA5124@kroah.com>
References: <1407094100-20107-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407094100-20107-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 09:28:20PM +0200, Martin Kepplinger wrote:
> Use the common kernel coding style, so don't use C99 // comments.
> If too long, where reasonable, they are shortened as well.
> 
> Some old internal comments about date and author of changes are
> removed.
> 
> This provides a more consistent view and hopefully encourages to
> look at it.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This changes only a part of rtl8192u's comments. When this is desired,
> one can go about and change the rest of the driver.
> 
> build-tested. applies to -next20140801

Really?  This doesn't seem to apply at all to me :(

thanks,

greg k-h
