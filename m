Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaAPOU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:20:26 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45704 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaAPOUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:20:23 -0500
Date: Thu, 16 Jan 2014 17:17:22 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 7/8] zram: drop not used table `count' member
Message-ID: <20140116141722.GA2176@swordfish.minsk.epam.com>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-8-git-send-email-sergey.senozhatsky@gmail.com>
 <52D7E41A.1060408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D7E41A.1060408@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/16/14 14:52), Jerome Marchand wrote:
> On 01/16/2014 02:12 PM, Sergey Senozhatsky wrote:
> > struct table `count' member is not used.
> 
> What was the intended use of this counter anyway?
> 
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/block/zram/zram_drv.h | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
> > index 58d4ac5..1d5b1f5 100644
> > --- a/drivers/block/zram/zram_drv.h
> > +++ b/drivers/block/zram/zram_drv.h
> > @@ -64,7 +64,6 @@ enum zram_pageflags {
> >  struct table {
> >  	unsigned long handle;
> >  	u16 size;	/* object size (excluding header) */
> > -	u8 count;	/* object ref count (not yet used) */
> >  	u8 flags;
> 
>

> I noticed that your earlier version of this patch changed the
> flags size to 16. What has changed?
> 

nothing really. I was going to extend flags, but changed my plans. so it was
a leftover.

	-ss

> Jerome
> 
> >  } __aligned(4);
> >  
> > 
> 
