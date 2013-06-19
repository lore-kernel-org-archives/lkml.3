Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3FSHJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:09:10 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:35880 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3FSHJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:09:08 -0400
Date: Wed, 19 Jun 2013 09:09:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 13/48] s390/pci: Implement IRQ functions if !PCI
Message-ID: <20130619090900.3dc0aa81@mschwide>
In-Reply-To: <20130618173540.GP4752@decadent.org.uk>
References: <20130618161725.912524266@linuxfoundation.org>
	<20130618161727.767561192@linuxfoundation.org>
	<20130618173540.GP4752@decadent.org.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061907-8372-0000-0000-000006597D21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jun 2013 18:35:40 +0100
Ben Hutchings <ben@decadent.org.uk> wrote:

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

I guess that all of the relevant kernels that are build for s390 are SMP
enabled. The patch fixes fallout in a number of PCI drivers and should
go in as is. The patch to fix the !SMP build will go on top.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

