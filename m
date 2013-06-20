Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161124Ab3FTTWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:22:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab3FTTWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:22:00 -0400
Date: Thu, 20 Jun 2013 12:21:59 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [ 13/48] s390/pci: Implement IRQ functions if !PCI
Message-ID: <20130620192159.GC336@kroah.com>
References: <20130618161725.912524266@linuxfoundation.org>
 <20130618161727.767561192@linuxfoundation.org>
 <20130618173540.GP4752@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618173540.GP4752@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:35:40PM +0100, Ben Hutchings wrote:
> On Tue, Jun 18, 2013 at 09:17:39AM -0700, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> > 
> > commit c46b54f7406780ec4cf9c9124d1cfb777674dc70 upstream.
> > 
> > All architectures must implement IRQ functions.  Since various
> > dependencies on !S390 were removed, there are various drivers that can
> > be selected but will fail to link.  Provide a dummy implementation of
> > these functions for the !PCI case.
> [...]
> 
> This breaks !SMP builds, so it's probably best to defer this until the
> following fix is in mainline.

Now dropped, thanks.

greg k-h
