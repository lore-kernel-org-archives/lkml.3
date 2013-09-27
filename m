Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3I0PlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:41:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3I0PlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:41:16 -0400
Date: Fri, 27 Sep 2013 08:41:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Berglund <martin@rogsta.net>
Cc: dan.carpenter@oracle.com, teddy.wang@siliconmotion.com.cn,
        wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: sm7xxfb: fixed line break coding style issues
Message-ID: <20130927154115.GB3238@kroah.com>
References: <20130927122728.GE6192@mwanda>
 <1380296351-18906-1-git-send-email-martin@rogsta.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380296351-18906-1-git-send-email-martin@rogsta.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:39:11PM +0200, Martin Berglund wrote:
> On Fri, Sep 27, 2013 at 03:27:29PM +0300, Dan Carpenter wrote:
> > On Fri, Sep 27, 2013 at 02:08:07PM +0200, Martin Berglund wrote:
> > > @@ -508,9 +506,8 @@ static void sm7xx_set_timing(struct smtcfb_info *sfb)
> > >  
> > >  			/* init SEQ register SR30 - SR75 */
> > >  			for (i = 0; i < SIZE_SR30_SR75; i++)
> > > -				if (((i + 0x30) != 0x62) \
> > > -					&& ((i + 0x30) != 0x6a) \
> > > -					&& ((i + 0x30) != 0x6b))
> > > +				if (((i + 0x30) != 0x62) && ((i + 0x30) != 0x6a)
> > > +							&& ((i + 0x30) != 0x6b))
> > 
> > The prefered way would be to align this like this:
> > 
> > 				if ((i + 0x30) != 0x62 &&
> > 				    (i + 0x30) != 0x6a &&
> > 				    (i + 0x30) != 0x6b)
> > 
> > regards,
> > dan carpenter
> > 
> 
> New patch.
> 
> Signed-off-by: Martin Berglund <martin@rogsta.net>

Can you please resend this in a format I can apply it in, without
needing to edit the patch body by hand?  I deal with thousands of
patches every month, and if I have to edit them all, that cuts down my
ability to apply them greatly.

thanks,

greg k-h
