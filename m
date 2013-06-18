Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab3FRRmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:42:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3FRRmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:42:36 -0400
Date: Tue, 18 Jun 2013 10:42:35 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [ 13/48] s390/pci: Implement IRQ functions if !PCI
Message-ID: <20130618174235.GA32610@kroah.com>
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

Can you resend the needed git ids to me when they both go in, otherwise
I'm going to forget about this.

thanks,

greg k-h
