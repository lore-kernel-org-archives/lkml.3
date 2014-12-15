Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbaLOUyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:54:04 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56757 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaLOUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:54:02 -0500
Date: Mon, 15 Dec 2014 18:53:55 -0200
From: Eduardo Barretto <edusbarretto@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: hfa384x_usb: fixed an 'else' statement
 coding style issue
Message-ID: <20141215205355.GA5831@archer>
References: <1418608974-22509-1-git-send-email-edusbarretto@gmail.com>
 <1418609490.2674.7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418609490.2674.7.camel@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the quick feedback. 
It was my first patch to the kernel and I wanted to be sure it would get right to the community.
I'll be making a version two with the consideration you brought me.

Thank you again,
Best regards,

Eduardo Barretto

On Sun, Dec 14, 2014 at 06:11:30PM -0800, Joe Perches wrote:
> On Mon, 2014-12-15 at 00:02 -0200, Eduardo Barretto wrote:
> > Fixed a coding style issue
> []
> > diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
> []
> > @@ -4123,12 +4123,11 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
> >  			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
> >  				 pdrcode);
> >  			return 1;
> > -		} else {
> > -			/* bad code */
> > -			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
> > -				 pdrcode);
> > -			return 0;
> >  		}
> > +		/* bad code */
> > +		pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
> > +			 pdrcode);
> > +		return 0;
> >  	}
> >  	return 0;		/* avoid compiler warnings */
> >  }
> 
> While this patch isn't necessary, if any change is
> done, it might better to not have two consecutive
> return 0; uses.
> 
> 
