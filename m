Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaGMBkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 21:40:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaGMBkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 21:40:02 -0400
Date: Sat, 12 Jul 2014 18:44:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lucas Tanure <tanure@linux.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] staging: android: Clean up binder_buffer_size()
Message-ID: <20140713014430.GA16087@kroah.com>
References: <20140713005009.GA1926@archDesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140713005009.GA1926@archDesk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 09:50:09PM -0300, Lucas Tanure wrote:
> Kernel coding style. Remove useless else statement after return.
> 
> Signed-off-by: Lucas Tanure <tanure@linux.com>
> ---
>  drivers/staging/android/binder.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

What tree are you making this patch against?  Someone already has this
patch accepted into my staging-next branch, which means that linux-next
also should show this change in it.

thanks,

greg k-h
