Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab3GWKKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:10:48 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33643 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3GWKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:10:47 -0400
Message-ID: <1374574241.17286.8.camel@desktop>
Subject: Re: [PATCH] Staging: bcm: Qos: Fix some coding style issues
From: Lilis Iskandar <veeableful@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 18:10:41 +0800
In-Reply-To: <20130723095416.GM5585@mwanda>
References: <1374571229.15906.3.camel@desktop>
	 <20130723095416.GM5585@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I have already accepted my fate when I submitted the patch. Though it's
really great that I receive a response so fast :)

Regarding the braces, I thought it would be more readable that way
because of the long code wrapping inside the "if" parameter. I'll fix it
and send the patches again in pieces. Should I send a new mail or reply
to this thread?

Lilis

On Tue, 2013-07-23 at 12:54 +0300, Dan Carpenter wrote:
> Hi hi,
> 
> Welcome first time submitter newbie.  :)  The tradition is to reject
> first time code submissions in the meanest and grumpiest way
> possible.
> 
> On Tue, Jul 23, 2013 at 05:20:29PM +0800, Lilis Iskandar wrote:
> > >From a2f8b299baee0e075d548d2bbf77619373035446 Mon Sep 17 00:00:00 2001
> > From: Lilis Iskandar <veeableful@gmail.com>
> > Date: Tue, 23 Jul 2013 17:08:37 +0800
> > Subject: [PATCH] Staging: bcm: Qos: Fix some coding style issues
> 
> This header stuff is not needed.  See if you can figure out how to
> get rid of it.
> 
> You are fixing too many kinds of problems at once so the patch is
> impossible to review.  Please break it up into one kind of issue
> per patch.
> 
> > -		if(FALSE == (bClassificationSucceed =
> > +		if (FALSE == (bClassificationSucceed =
> >  			MatchSrcPort(pstClassifierRule,
> > -				ntohs((iphd->protocol == UDP)?
> > -				xprt_hdr->uhdr.source:xprt_hdr->thdr.source))))
> > +			ntohs((iphd->protocol == UDP)?
> > +			xprt_hdr->uhdr.source : xprt_hdr->thdr.source))))
> > +		{
> >  			break;
> > +		}
> 
> I don't know why you are adding curly braces here but they don't
> belong.  Braces are explained in CodingStyle.
> 
> regards,
> dan carpenter
> 


