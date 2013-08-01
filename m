Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3HAIKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:10:02 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38838 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848Ab3HAIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:09:56 -0400
Message-ID: <1375344595.2034.38.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Date: Thu, 01 Aug 2013 01:09:55 -0700
In-Reply-To: <20130801075656.GA8074@kroah.com>
References: <1375316960686@kroah.org> <1375343328.2034.34.camel@joe-AO722>
	 <20130801075656.GA8074@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 15:56 +0800, Greg KH wrote:
> On Thu, Aug 01, 2013 at 12:48:48AM -0700, Joe Perches wrote:
> > There are several drivers in drivers/net/usb/ that
> > do not have specific MAINTAINERS that should have
> > emails forwarded to the linux-usb mailing list.

> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > +USB NETWORKING DRIVERS
> > +L:	linux-usb@vger.kernel.org
> > +S:	Odd Fixes
> > +F:	drivers/net/usb/
> 
> But netdev is the one that applies these patches, not linux-usb, so this
> isn't correct either.
> 
> sorry,

Lots of "maintainers" don't apply patches.

This is simply a means to forward patches to
relevant lists that may have reviewers that care
about changes to certain files.

You suggested that linux-usb should get copies
of these patches.

These files are not marked as "Maintained", just
"Odd fixes".  I suppose these could be marked
"Orphan" instead.

You have a suggestion otherwise?

