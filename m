Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaEDBSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:18:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbaEDBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:18:48 -0400
Date: Sat, 3 May 2014 20:58:02 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Tair Rzayev <tair.rzayev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: keucr: smilmain.c: Fix sparse warning
Message-ID: <20140504005802.GB21590@kroah.com>
References: <53555897.10409@gmail.com>
 <20140425222459.GA25868@kroah.com>
 <53654AE3.9040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53654AE3.9040702@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 11:00:35PM +0300, Tair Rzayev wrote:
> 
> On 2014.04.26. 01:24, Greg KH wrote:
> > On Mon, Apr 21, 2014 at 08:42:47PM +0300, Tair wrote:
> >> From: Tair Rzayev <tair.rzayev@gmail.com>
> >>
> >> Fix "Should be static" sparse warning:
> >> * Add Check_D_MediaFmt() declaration to smil.h;
> >> * Move Check_D_MediaFmt() implementation up in smilmain.c to keep
> >>   all the non-static functions at the top of the file;
> >> * Include "init.h" into "smil.h", remove externs from "smil.h"
> >>   which are no longer needed;
> >> * SM_Init[] and SM_Rdwr[] are renamed because otherwise SM_Init[]
> >>   collides with SM_Init() from "smil.h".
> > 
> > That's a lot of things to do all at once.
> > 
> > In fact, it doesn't apply to my tree anymore because someone else just
> > did a part of what you did, so this might not be needed anymore.  Can
> > you please rebase your patch on top of my staging-next branch on the
> > staging.git tree on git.kernel.org and resend it?
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Rebased against suggested tree and branch.
> 
> Most of the changes were already applied by another developer so leaving only 
> cosmetic stuff from my original patch:
> * Move Check_D_MediaFmt() implementation up in smilmain.c to keep all the 
>   non-static functions at the top of the file;
> * Remove unnecessary extern and newlines from "init.h";
> 
> Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
> ---
>  drivers/staging/keucr/init.h     |  4 ----
>  drivers/staging/keucr/smilmain.c | 34 +++++++++++++++++-----------------
>  2 files changed, 17 insertions(+), 21 deletions(-)

Please resend this as a whole new email, one that I don't have to edit
by hand in order to apply it.

thanks,

greg k-h
