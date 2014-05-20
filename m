Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbaETUVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:21:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaETUVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:21:09 -0400
Date: Wed, 21 May 2014 05:20:58 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] appledisplay: Convert /n to \n
Message-ID: <20140520202058.GA29243@kroah.com>
References: <cover.1398390579.git.joe@perches.com>
 <9bbe7dc36e6b609512f166e10b6b99a706fbbd11.1398390579.git.joe@perches.com>
 <1400614013.26709.29.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400614013.26709.29.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:26:53PM -0700, Joe Perches wrote:
> On Thu, 2014-04-24 at 18:51 -0700, Joe Perches wrote:
> > Use a newline character appropriately.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> 
> Greg?  Ping?
> 
> You inadvertently added this "/n" use in
> commit 0a3fd536e685e0ceb646de1a43821bd11c0be75c
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Tue May 1 21:33:54 2012 -0700
> 
>     USB: appledisplay.c: remove dbg() usage
>     
>     dbg() was a very old USB-specific macro that should no longer
>     be used. This patch removes it from being used in the driver
>     and uses dev_dbg() instead.

Sorry, it's in my queue, just stalled due to traveling.  It's not lost,
don't worry.

greg k-h
