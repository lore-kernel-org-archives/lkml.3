Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaGRXPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:15:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaGRXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:15:31 -0400
Date: Fri, 18 Jul 2014 16:15:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Igor Bezukh <igbzkh@gmail.com>
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt6655: apply kernel coding style to
 wCommandTimerWait function
Message-ID: <20140718231531.GA29920@kroah.com>
References: <1405708513-27831-1-git-send-email-igbzkh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405708513-27831-1-git-send-email-igbzkh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 09:35:13PM +0300, Igor Bezukh wrote:
> Since there is a lot of stuff that need to be changed in order to meet the kernel
> coding style in wcmd.c file, I've decided to fix function-per-patch.
> The following changes were made in vCommandTimerWait function:
> 
> - Camel case change:
>    - MSecond ---> msec
>    - hDdeviceContext ---> private
>    - pDevice ---> priv
> - Removed redundant return
> - Removed redndant comment
> 
> In future patches, I will also change the function name itself.

A better way to do this, that is easier to review, is to do, on a
per-file basis, one thing, like "remove redundant return", or "remove
unneeded comments".

Having to review all of these changes at once, even for something as
"small" as a single function, is much harder than making sure you only
do one thing, and do it all at once.

So, can you break it up in this way instead?

thanks,

greg k-h
