Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3JJUCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 16:02:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:48252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756977Ab3JJUCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 16:02:46 -0400
Message-ID: <1381435346.5630.7.camel@pasglop>
Subject: Re: [PATCH] sysfs/bin: Fix size handling overflow for bin_attribute
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Oct 2013 07:02:26 +1100
In-Reply-To: <20131010174011.GA1376@kroah.com>
References: <1381378788.4330.30.camel@pasglop>
	 <1381388635.4330.37.camel@pasglop> <20131010173847.GD13759@kroah.com>
	 <20131010174011.GA1376@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 10:40 -0700, Greg KH wrote:
> > This file (fs/sysfs/bin.c) is no longer in linux-next as Tejun merged it
> > with the other file handling code in sysfs, to remove a bunch of
> > duplicated logic.
> > 
> > So, could you look at linux-next and see if this is still an issue there
> > or not?
> 
> Ah, nevermind, I just looked, and it still is an issue there, I'll
> hand-edit the patch to apply properly, thanks.

Ah sorry, nice to see that Tejun cleaned that stuff up, it took me a while
to find my way around :-)

Cheers,
Ben.


