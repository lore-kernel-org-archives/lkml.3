Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762003Ab3EDR7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 13:59:24 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10110 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab3EDR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 13:59:22 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18EBK9fl4WbLwW0CK1w1lpy1KlCgy1F+GY=
Date: Sat, 4 May 2013 13:58:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: add support for Marvell Orion SoCs
Message-ID: <20130504175839.GM31290@titan.lakedaemon.net>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130502185322.GA29333@obsidianresearch.com>
 <5182B902.7040908@gmail.com>
 <20130502193510.GA29522@obsidianresearch.com>
 <5182C322.3030304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182C322.3030304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 09:48:50PM +0200, Sebastian Hesselbarth wrote:
> On 05/02/2013 09:35 PM, Jason Gunthorpe wrote:
> >I have kirkwood HW but I haven't had time to make newer kernels run on
> >it, otherwise I'd test it too :(
> 
> I also have kirkwood HW but that will cut me from email as I use it as
> relay server ;) Maybe I can turn it into a test bed for a while.
> 
> There is also Orion5x and Discovery Innovation (mv78xx0) to be tested.
> 
> @Jason Cooper: I will merge both irqchip and dove patches into one
> patch set. I wasn't earlier because I didn't want the above SoCs to
> slow down patch integration. And I will split dtsi changes into
> separate patches as requested.

Understood.  I'd prefer to keep patches developed together in the same
series, that way, discussions about who is taking what and which patch
depends on what are all in the same thread of the archives.

It's difficult because some series (eg pcie) touch many different areas
and _need_ to be kept together because of the chain of dependencies.
Most other series though, aren't in that situation.

thx,

Jason.
