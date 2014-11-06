Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaKFCTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:19:38 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55063 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbaKFCTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:19:36 -0500
X-Sasl-enc: 9SO9EKgF3YXS270ZDznMRHfW6HJiEEzhotGUtM9cS3/9 1415240375
Date: Wed, 5 Nov 2014 18:19:34 -0800
From: Greg KH <greg@kroah.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20141106021934.GB17253@kroah.com>
References: <20141105151825.26c53948@canb.auug.org.au>
 <20141105043030.GB10613@kroah.com>
 <1415176413.20372.206.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415176413.20372.206.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:33:33AM +0100, Paul Bolle wrote:
> On Tue, 2014-11-04 at 20:30 -0800, Greg KH wrote:
> > On Wed, Nov 05, 2014 at 03:18:25PM +1100, Stephen Rothwell wrote: 
> > > Today's linux-next merge of the usb tree got a conflict in
> > > drivers/usb/host/Kconfig between commit cd6e245a2d06 ("usb: Remove
> > > references to non-existent PLAT_S5P symbol") from the usb.current tree
> > > and commit dd3cf17488b1 ("usb: host: Remove optional dependencies on
> > > PLAT_S5P") from the usb tree.
> > > 
> > > I fixed it up (I used the usb tree version) and can carry the fix as
> > > necessary (no action is required).
> > 
> > That's the correct fix, thanks for doing that.
> 
> Shouldn't that be the other way round?

Sorry, you are right, I read the merge backwards.

> I thought we would choose Sylwester's commit from the usb.current tree
> over my commit from the usb tree. Or will Sylwester's commit end up in
> linux-next through yet another usb tree?

I will do that when I do the merge in my tree when it hits Linus's tree.

thanks,

greg k-h
