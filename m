Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaE1V0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:26:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaE1V0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:26:52 -0400
Date: Wed, 28 May 2014 14:30:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Scott Weir <sjw0410@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix Missing a blank line after
 declarations warnings
Message-ID: <20140528213027.GA15313@kroah.com>
References: <1401267171-4106-1-git-send-email-sjw0410@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401267171-4106-1-git-send-email-sjw0410@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 06:52:51PM +1000, Scott Weir wrote:
> This patch corrects coding style issue:
> WARNING: Missing a black line after declarations
> 
> Signed-off-by: Scott Weir <sjw0410@gmail.com>
> ---
>  drivers/staging/android/sync_debug.c | 4 ++++

This file isn't in my tree.  Always work against linux-next, not Linus's
tree for new patches.

thanks,

greg k-h
