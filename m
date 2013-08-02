Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3HBD7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 23:59:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3HBD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:59:45 -0400
Date: Fri, 2 Aug 2013 12:01:02 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
Message-ID: <20130802040102.GA16363@kroah.com>
References: <1375316960686@kroah.org>
 <1375343328.2034.34.camel@joe-AO722>
 <20130801075656.GA8074@kroah.com>
 <1375344595.2034.38.camel@joe-AO722>
 <20130802033033.GA2658@kroah.com>
 <1375415410.2034.100.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375415410.2034.100.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 08:50:10PM -0700, Joe Perches wrote:
> On Fri, 2013-08-02 at 11:30 +0800, Greg KH wrote:
> > On Thu, Aug 01, 2013 at 01:09:55AM -0700, Joe Perches wrote:
> > > Lots of "maintainers" don't apply patches.
> > I have no idea what you are meaning here.
> 
> Just that maintainers aren't necessarily appliers.
> In fact, most aren't.
> 
> > Add netdev to the L: list as well.
> 
> I don't think it's necessary.
> get_maintainers already shows that via the
> NETWORKING DRIVERS section F: drivers/net/

Ah, I thought this entry would have overridden it, sorry about that.

Can you resend this so that I can apply it?

thanks,

greg k-h
