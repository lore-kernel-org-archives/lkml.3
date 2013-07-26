Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3GZN7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:59:36 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27236 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932186Ab3GZN7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:59:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ksMiMjTqbhYIScJ9gKUDukKV7xNq8uf0=
Date: Fri, 26 Jul 2013 09:59:04 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130726135904.GK29916@titan.lakedaemon.net>
References: <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726132709.GH29916@titan.lakedaemon.net>
 <20130726133802.GN24642@n2100.arm.linux.org.uk>
 <20130726134551.GI29916@titan.lakedaemon.net>
 <1374846653.14574.96.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374846653.14574.96.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:50:53PM +0100, David Woodhouse wrote:
> On Fri, 2013-07-26 at 09:45 -0400, Jason Cooper wrote:
> > 
> > We agree, I was just highlighting that attributes outside of chosen can
> > and need to be rewritten by the bootloader.
> 
> Yes, absolutely. I had actually edited and re-ordered my message
> <1374831744.2923.42.camel@shinybook.infradead.org> to try to make that
> clearer by explicitly saying that the nodes which describe hardware
> devices *can* change, before I ever made any mention of /chosen as
> something which is almost *exclusively* dynamic.
> 
> Evidently that wasn't sufficient clarification. :)

It was, I just wanted to spell out an actual use-case for folks who are
new to devicetree.  Also, I was trying to gently poke everyone to take a
look at the mvebu-mbus binding Ezequiel just posted ;-)

Arnd Bergman and Jason Gunthorpe (and others) have reviewed it to death,
but with this new push for review by the devicetree maintainers, we
thought it best to repost it here (devicetree ml) before merging it.

thx,

Jason.
