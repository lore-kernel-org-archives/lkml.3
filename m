Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3FRRfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:35:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54251 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab3FRRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:35:46 -0400
Date: Tue, 18 Jun 2013 18:35:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Message-ID: <20130618173540.GP4752@decadent.org.uk>
References: <20130618161725.912524266@linuxfoundation.org>
 <20130618161727.767561192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618161727.767561192@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 13/48] s390/pci: Implement IRQ functions if !PCI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:17:39AM -0700, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 3.9-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> commit c46b54f7406780ec4cf9c9124d1cfb777674dc70 upstream.
> 
> All architectures must implement IRQ functions.  Since various
> dependencies on !S390 were removed, there are various drivers that can
> be selected but will fail to link.  Provide a dummy implementation of
> these functions for the !PCI case.
[...]

This breaks !SMP builds, so it's probably best to defer this until the
following fix is in mainline.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
