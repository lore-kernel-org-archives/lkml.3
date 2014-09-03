Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbaICPmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:42:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43374 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868AbaICPmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:42:37 -0400
Date: Wed, 3 Sep 2014 18:41:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: unisys: uislib: uisqueue.c: rewrite of
 do_locked_client_insert
Message-ID: <20140903154130.GL6549@mwanda>
References: <1409681795-23262-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20140903084038.GE6600@mwanda>
 <20140903085944.GA1184@sudip-PC>
 <20140903144325.GA15176@sudip-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140903144325.GA15176@sudip-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 08:13:25PM +0530, Sudip Mukherjee wrote:
> On Wed, Sep 03, 2014 at 02:29:44PM +0530, Sudip Mukherjee wrote:
> > On Wed, Sep 03, 2014 at 11:40:38AM +0300, Dan Carpenter wrote:
> > > On Tue, Sep 02, 2014 at 11:46:35PM +0530, Sudip Mukherjee wrote:
> > > > From: Sudip Mukherjee <sudip@vectorindia.org>
> > > 
> > > I really would prefer if you just figured out your email settings so
> > > this isn't needed.  The From: header is mostly used for people
> > > forwarding patches from other people.  We have allowed people to use
> > > the From header like this if they can't get their corporate email
> > > configured properly but I try to discorage it.  If everyone starts using
> > > From headers like this then it becomes a pain to deal with.
> > > 
> > I will configure the corporate mail. I am the server admin , so there should
> > not be any problem in settings. :)
> > 
> v4 of the patch was sent from the corporate mail. The settings were done.
> But the problem is coming in a different area. I have given strict DMARC check 
> for the corporate mail server. DMARC = domain based message authentication.
> So the mail i sent reached all the list subscriber from a different server than 
> our designated server , and as a result it has been marked as spam in many places.
> I have already received a few complaints regarding that.
> Is there any other way that i send the patch from my personal account , 
> and use my corporate mail in Signed-off-by ... 

I guess it's ok by me.  It's up to Greg.

regards,
dan carpenter

