Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966165Ab3E2TSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:18:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30911 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965810Ab3E2TSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:18:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vW7lYkbnX+iD5D8QJJG621OZZyJRcJsw=
Date: Wed, 29 May 2013 15:17:48 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130529191748.GW31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130529190204.6058.85682@quantum>
 <51A65185.1020307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A65185.1020307@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:05:41PM +0200, Sebastian Hesselbarth wrote:
> On 05/29/2013 09:02 PM, Mike Turquette wrote:
> >Quoting Sebastian Hesselbarth (2013-05-10 18:08:00)
> >>Marvell EBU SoCs share some common clock functions that register core
> >>clocks or clock gates from SoC specific data. These clock drivers are
> >>organized by function and over time the drivers filled up with #ifdefs
> >>to separate different SoC specific code.
> >>
> ...
> >>@Mike: As this only touches MVEBU related code, I suggest to take it
> >>all through the corresponding ARM branch.
> >>
> >Sorry for the tardy response.  This cleanup looks really good.  If it's
> >not too late:
> >
> >Acked-by: Mike Turquette<mturquette@linaro.org>
> >
> >If the branch is already pulled into arm-soc don't worry about the Ack.
> 
> thanks for the Ack, the corresponding pull request has been sent some
> hours ago by Jason Cooper. It has not been pulled into arm-soc, so it
> is just in time ;)

Just talked to Olof, looks like I can squeeze it in ;-)

thx,

Jason.
