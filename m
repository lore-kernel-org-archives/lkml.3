Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3EVRCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:02:35 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57780 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756195Ab3EVRCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:02:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19x/Z0/Koa8vrKo8ncMkUyDQjYTAvqrTFA=
Date: Wed, 22 May 2013 13:01:57 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "tiejun.chen" <tiejun.chen@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio
 device tree nodes
Message-ID: <20130522170157.GF31290@titan.lakedaemon.net>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130521174849.GL26249@lunn.ch>
 <519C9333.20609@gmail.com>
 <519C9822.9040909@windriver.com>
 <519C9A66.3050807@gmail.com>
 <20130522131010.GB31290@titan.lakedaemon.net>
 <20130522165908.GB12320@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522165908.GB12320@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:59:08AM -0600, Jason Gunthorpe wrote:
> On Wed, May 22, 2013 at 09:10:10AM -0400, Jason Cooper wrote:
> 
> > iirc, our solution to this was to parse the ATAGs for the mac addr and
> > update the appended dtb.  This way, module load and unload would work
> > without loosing the mac address.  I believe Jason Gunthorpe has a patch
> > to atags_to_fdt() for this...  This should allow us to get rid of the
> > clocks hack.
> 
> Sorry, no, we don't use ATAGs here, our platforms start the kernel
> with a correct DTB that has the correct mac address to use. My patch
> was to have the driver accept it, and I think Sebastian has already
> got that functionality...

Yes, you're right.

thx,

Jason.
