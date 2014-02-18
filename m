Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaBRLAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 06:00:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28792 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaBRLAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 06:00:03 -0500
Date: Tue, 18 Feb 2014 13:59:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: fix brace-related coding
 style issues in hwdrv_apci035.c
Message-ID: <20140218105944.GM26722@mwanda>
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
 <53020B92.6060805@mev.co.uk>
 <1392669907.92125.YahooMailNeo@web164001.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392669907.92125.YahooMailNeo@web164001.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 12:45:07PM -0800, Chase Southwood wrote:
> >On Monday, February 17, 2014 7:16 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
> 
> >>On 2014-02-16 08:40, Chase Southwood wrote:
> >> This patch for hwdrv_apci035 removes some unneeded braces, and moves some
> >> improperly placed braces to the correct position, as found by checkpatch.
> >> It also removes a commented out if-statement that I found whilst cleaning
> >> braces that is identical to another un-commented if-statement directly
> >> above it, so it is just added clutter and so we can delete it to clean up
> >> further.
> >>
> >> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> >> ---
> >> So I decided to venture into addi-data today and found that most of the
> >> files in there are very messy from a style standpoint.  This is the first
> >> (of probably a few) patchsets to try and clean those files up a bit.  I
> >> hope that this will be helpful!
> >
> >Quite a few have been cleaned up extensively by Hartley, but they needed 
> >more extensive changes than clean-ups due to them trying to handle 
> >things differently to the normal comedi way of doing things.
> 
> Oh, I see.  Makes perfect sense.  Well like I said, if cleaning them
> up a bit will help make reworking them any easier or seems like useful
> work, I'd be happy to continue making them a little easier on the
> eyes!

Ian acked your patch already...  If you want to clean these up then go
for it.  There is no reason Hartley should have to do all the work.

But consider doing more "extensive" cleanups.  Instead of just shifting
the comments over in [patch 2/4] you could change the format to kernel
style.  Newbies are too timid.  Look through the work that Hartley has
done and try copy it.

regards,
dan carpenter

