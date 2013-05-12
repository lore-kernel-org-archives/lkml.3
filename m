Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3ELVnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 17:43:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58657 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab3ELVng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 17:43:36 -0400
X-Sasl-enc: AsA5dc9cI8inCzsn0DudK00XvKZkn6cLQUvbBXqKzKAP 1368395015
Date: Sun, 12 May 2013 14:43:41 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Subject: Re: Build regressions/improvements in v3.10-rc1 (staging)
Message-ID: <20130512214341.GA29578@kroah.com>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
 <alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
 <alpine.DEB.2.00.1305122249360.5463@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1305122249360.5463@ayla.of.borg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 10:50:08PM +0200, Geert Uytterhoeven wrote:
> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> > However, the full list of errors isn't that unmanageable, so I'm following
> > up with a digested list...
> 
> drivers/staging/android/logger.c:316:4: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
> drivers/staging/android/logger.c:483:14: error: incompatible types when assigning to type 'uid_t' from type 'kuid_t': 2 errors in 2 logs
> drivers/staging/android/logger.c:631:4: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
> drivers/staging/android/logger.c:686:5: error: incompatible type for argument 3 of 'get_next_entry_by_uid': 2 errors in 2 logs
> 	v3.10-rc1/powerpc/powerpc-randconfig v3.10-rc1/sh4/sh-randconfig

I have a patch for this in my inbox, I'll get to it before 3.10-rc2 is
out, thanks.

> drivers/staging/comedi/drivers/ni_labpc.c:980:9: error: implicit declaration of function 'virt_to_bus' [-Werror=implicit-function-declaration]: 2 errors in 2 logs
> 	v3.10-rc1/powerpc/powerpc-allmodconfig v3.10-rc1/powerpc/powerpc-allyesconfig

I'm pretty sure people are also already working on this, thanks.

greg k-h
