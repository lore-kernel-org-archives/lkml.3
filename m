Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaLBKjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:39:21 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47729 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLBKjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:39:18 -0500
Date: Tue, 2 Dec 2014 16:09:07 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: remove duplicate header
Message-ID: <20141202103907.GA9991@sudip-PC>
References: <1417511098-9139-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20141202094654.GB8792@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202094654.GB8792@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 01:46:54AM -0800, Jeremiah Mahler wrote:
> Sudip,
> 
> On Tue, Dec 02, 2014 at 02:34:58PM +0530, Sudip Mukherjee wrote:
> > these header files were included two times
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> >  drivers/staging/unisys/include/timskmod.h | 1 -
> >  drivers/staging/unisys/uislib/uisutils.c  | 1 -
> >  2 files changed, 2 deletions(-)
> > 
> > diff --git a/drivers/staging/unisys/include/timskmod.h b/drivers/staging/unisys/include/timskmod.h
> > index de11f44..cff7983 100644
> > --- a/drivers/staging/unisys/include/timskmod.h
> > +++ b/drivers/staging/unisys/include/timskmod.h
> > @@ -31,7 +31,6 @@
> >  #include <linux/slab.h>
> >  #include <linux/errno.h>
> >  #include <linux/interrupt.h>
> > -#include <linux/sched.h>
> >  #include <linux/wait.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/proc_fs.h>
> > diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
> > index a8466e3..7149add 100644
> > --- a/drivers/staging/unisys/uislib/uisutils.c
> > +++ b/drivers/staging/unisys/uislib/uisutils.c
> > @@ -27,7 +27,6 @@
> >  #include "vbushelper.h"
> >  #include <linux/uuid.h>
> >  #include <linux/skbuff.h>
> > -#include <linux/uuid.h>
> >  #ifdef CONFIG_HIGHMEM
> >  #include <linux/highmem.h>
> >  #endif
> 
> There are two duplicates of the second one.  Lines: 21, 28 and 30.

oops ... missed that
i will send a v2

thanks
sudip
> 
> Good find :
> 
> -- 
> - Jeremiah Mahler
