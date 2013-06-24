Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab3FXWkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:40:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42903 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab3FXWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:40:37 -0400
X-Sasl-enc: L3oDM0+Cl+zFKYUDBHAMFfVjrr/Kd2Gl/iYXaHMhIVZD 1372113636
Date: Mon, 24 Jun 2013 15:40:35 -0700
From: Greg KH <greg@kroah.com>
To: Peng Tao <bergwolf@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20130624224035.GD24099@kroah.com>
References: <20130619181031.8b53acc44466ba70a47e1fcd@canb.auug.org.au>
 <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy4z-ufq2GEtzC17TBbrNGWv6ZUzuVe=VLBH48Df=3HZxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 05:26:57PM +0800, Peng Tao wrote:
> On Wed, Jun 19, 2013 at 4:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi all,
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:203:0,
> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:67,
> >                  from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:41:
> > drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_dev_need_failover':
> > drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:215:16: error: implicit declaration of function 'NIPQUAD' [-Werror=implicit-function-declaration]
> >   static struct libcfs_debug_msg_data msgdata;      \
> >                 ^
> Thanks for reporting!
> 
> It is a bug in Lustre code that it is missing NIPQUAD definition on
> Linux platform. I will send fix later.

We are running out of time, my tree is pretty much closed for 3.11 now,
should I just disable the build of this module for 3.11?

thanks,

greg k-h
