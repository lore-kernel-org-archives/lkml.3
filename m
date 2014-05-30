Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaE3F4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:56:52 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53108 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbaE3F4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:56:51 -0400
Date: Fri, 30 May 2014 15:56:44 +1000
From: Scott Weir <sjw0410@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: fix Missing a blank line after
 declarations warnings
Message-ID: <20140530055644.GA1782@lubuntuVM>
References: <1401267171-4106-1-git-send-email-sjw0410@gmail.com>
 <20140528213027.GA15313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528213027.GA15313@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:30:27PM -0700, Greg KH wrote:
> On Wed, May 28, 2014 at 06:52:51PM +1000, Scott Weir wrote:
> > This patch corrects coding style issue:
> > WARNING: Missing a black line after declarations
> > 
> > Signed-off-by: Scott Weir <sjw0410@gmail.com>
> > ---
> >  drivers/staging/android/sync_debug.c | 4 ++++
> 
> This file isn't in my tree.  Always work against linux-next, not Linus's
> tree for new patches.
> 
> thanks,
> 
> greg k-h

This patch was made against linux-next. Is it better to use your staging tree?

thanks
