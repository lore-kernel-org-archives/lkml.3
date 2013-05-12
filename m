Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3ELPdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:33:04 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:61590 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab3ELPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:33:01 -0400
Date: Sun, 12 May 2013 08:33:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt Kilgore <mattkilgore12@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fixed coding style issues
Message-ID: <20130512153312.GA32210@kroah.com>
References: <1367199093-32341-1-git-send-email-mattkilgore12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367199093-32341-1-git-send-email-mattkilgore12@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 09:31:33PM -0400, Matt Kilgore wrote:
> From: Matt Kilgore <MattKilgore12@gmail.com>
> 
> Fixed coding style issues with comments, braces, and spacing.
> 
> Signed-off-by: Matt Kilgore <mattkilgore12@gmail.com>
> ---
>  drivers/staging/rtl8187se/r8180.h | 657 +++++++++++++++++++-------------------
>  1 file changed, 325 insertions(+), 332 deletions(-)

That's a lot of changes all in one patch, making it hard to review.
Care to break this up into "only do one thing" per patch and resend it?
Probably as a few patches.

thanks,

greg k-h
