Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaH3TW6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:22:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaH3TW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:22:57 -0400
Date: Sat, 30 Aug 2014 12:22:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Janet Liu <jianhua.ljh@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1 3/4] staging:lustre:lnet: lib-md.c erase C99 // comments
Message-ID: <20140830192256.GA11237@kroah.com>
References: <1409381769-2311-1-git-send-email-jianhua.ljh@gmail.com>
 <1409381853-2362-1-git-send-email-jianhua.ljh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409381853-2362-1-git-send-email-jianhua.ljh@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 02:57:33PM +0800, Janet Liu wrote:
> After changing the comments format, the other error disappears.
> So silences two checkpatch errors:
>   ERROR: do not use C99 // comments
>   ERROR: trailing statements should be on next line
> 
> Signed-off-by: Janet Liu <jianhua.ljh@gmail.com>
> ---
>  drivers/staging/lustre/lnet/lnet/lib-md.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This doesn't apply properly, maybe due to the first patch not being
applied?

Can you redo patches 1/4 and 3/4 and resend them?  I've taken 2/4 and
4/4 now.

thanks,

greg k-h
