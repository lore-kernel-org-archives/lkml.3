Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab3BVVsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:48:01 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46529 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3BVVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:48:00 -0500
Date: Fri, 22 Feb 2013 13:47:57 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Rientjes <rientjes@google.com>
Cc: George Zhang <georgezhang@vmware.com>, Andy King <acking@vmware.com>,
        Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] drivers, vmci: vmware vmci driver depends on CONFIG_NET
Message-ID: <20130222214757.GA14763@kroah.com>
References: <alpine.DEB.2.02.1302211344180.28115@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1302221236480.10081@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1302221236480.10081@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 12:37:29PM -0800, David Rientjes wrote:
> On Thu, 21 Feb 2013, David Rientjes wrote:
> 
> > CONFIG_VMWARE_VMCI requires CONFIG_NET, otherwise there is a link error:
> > 
> > drivers/built-in.o: In function `__qp_memcpy_from_queue.isra.11':
> > vmci_queue_pair.c:(.text+0x2d4509): undefined reference to `memcpy_toiovec'
> > drivers/built-in.o: In function `__qp_memcpy_to_queue.isra.12':
> > vmci_queue_pair.c:(.text+0x2d4709): undefined reference to `memcpy_fromiovec'
> > 
> 
> This link error has made it to Linus' tree, so hopefully this can be 
> merged and pushed before rc1.

Yes, give me a chance, it's still early in the merge window.  Actually,
for something so trivial as this, it will probably wait until after
3.9-rc1 is out, the number of people who build a running system without
CONFIG_NET is probably pretty small :)

Don't worry, the patch is not lost, it's in my "to-apply" queue.

thanks,

greg k-h
