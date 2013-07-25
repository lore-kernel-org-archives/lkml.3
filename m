Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3GYVD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 17:03:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38423 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab3GYVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:03:26 -0400
X-Sasl-enc: PiKps3CT7k29idh5fNJCGZzyJeAJ/fdBmCsbnygjX0+W 1374786205
Date: Thu, 25 Jul 2013 14:03:24 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: luis.henriques@canonical.com, ben@decadent.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, shangw@linux.vnet.ibm.com
Subject: Re: [40/85] net/tg3: Avoid delay during MMIO access
Message-ID: <20130725210324.GA6089@kroah.com>
References: <lsq.1374674565.832521875@decadent.org.uk>
 <87zjtbzz8j.fsf@canonical.com>
 <20130724.124504.1663757440011643606.davem@davemloft.net>
 <20130724.140907.326515349808465987.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724.140907.326515349808465987.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 02:09:07PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 24 Jul 2013 12:45:04 -0700 (PDT)
> 
> > From: Luis Henriques <luis.henriques@canonical.com>
> > Date: Wed, 24 Jul 2013 17:42:04 +0100
> > 
> >> I believe you didn't want to have these two invocations to the
> >> pci_channel_offline() function.  i guess you wanted to have one of
> >> these moved to the other branch of the 'if' statement.
> >> 
> >> [ btw, I've just replied to an email by David S. Miller about his
> >>   backport to 3.4 (and 3.2) of this commit. ]
> > 
> > Yes, indeed, both of these backports were done incorrectly.
> 
> Greg/Ben, please drop the tg3 patch of my networking bits from your
> queues, I'll send a fixed up version soon.

Now dropped from my 3.4-stable queue, thanks.

greg k-h
