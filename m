Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3GXPFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:05:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3GXPFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:05:15 -0400
Date: Wed, 24 Jul 2013 08:06:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Hocko <mhocko@suse.cz>, devel@driverdev.osuosl.org,
        konrad.wilk@oracle.com, Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, bob.liu@oracle.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] zcache: fix "zcache=" kernel parameter
Message-ID: <20130724150627.GF15095@kroah.com>
References: <1374245201-24474-1-git-send-email-p.sarna@partner.samsung.com>
 <7560549.NYTHa4SYx0@amdc1032>
 <20130724114157.GB3976@dhcp22.suse.cz>
 <4003586.oV5ROrQ3Ke@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4003586.oV5ROrQ3Ke@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:54:56PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> On Wednesday, July 24, 2013 01:41:57 PM Michal Hocko wrote:
> > On Wed 24-07-13 12:32:32, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > Hi,
> > > 
> > > On Wednesday, July 24, 2013 12:04:41 PM Michal Hocko wrote:
> > > > On Wed 24-07-13 12:02:35, Michal Hocko wrote:
> > > > > I have posted a similar fix quite some time ago and I guess Greg should
> > > > > already have it.
> > > > 
> > > > For reference https://lkml.org/lkml/2013/6/26/410
> > > 
> > > There was a reply from Greg:
> > > 
> > > 	https://lkml.org/lkml/2013/6/26/410
> > 
> > I guess you meant https://lkml.org/lkml/2013/6/26/569
> 
> Uh, yes.
> 
> > > and it seems that Greg's request has not been fullfilled.
> > 
> > Bob Liu has resent the patch (I cannot find the email in the archive).
> 
> Indeed, I've found it here:
> 
> http://comments.gmane.org/gmane.linux.kernel.mm/102484
> 
> > > Anyway Piotr's patch seems to be more complete:
> > > - it also fixes case in which invalid "zcache=" option is given (returns
> > >   an error value 1 while with your patch the code still erronously retuns 0)
> > > - it prints information about compressor type being used when "zcache="
> > >   option is used (your patch skips it due to addition of "goto out_alloc")
> > 
> > I do not care which one will make it I just pointed out that there is
> > another patch dealing with the same and it is a question how far that
> > one went.
> 
> OK.
> 
> Greg, could you please pick Piotr's patch?

Wait, I'm going to take the first one I got, from Michal, as that's the
original author here, not Piotr...

confused, and really grumpy about the whole zcache mess...

greg k-h
