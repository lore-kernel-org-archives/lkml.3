Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaGMTCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:02:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaGMTCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:02:49 -0400
Date: Sun, 13 Jul 2014 12:07:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas Tanure <tanure@linux.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] staging: android: Clean up
 binder_send_failed_reply
Message-ID: <20140713190719.GA31809@kroah.com>
References: <20140713144929.GA6656@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713144929.GA6656@archDesk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2014 at 11:49:29AM -0300, Lucas Tanure wrote:
> Kernel coding style. Remove useless else statement after return.
> 
> Signed-off-by: Lucas Tanure <tanure@linux.com>
> ---
>  drivers/staging/android/binder.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)

You didn't compile this patch :(

Or if you did, you ignored the fact that it now adds a warning to the
kernel build process, which is not allowed.  Please fix this up and
resend.

thanks,

greg k-h
