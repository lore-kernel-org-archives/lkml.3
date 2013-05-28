Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3E1UDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:03:55 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47528 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3E1UDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:03:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+CCKfoOmEUux/PZcQSUnC/Pkedj63kVRA=
Date: Tue, 28 May 2013 16:03:25 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130528200325.GF31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130528154047.GT31290@titan.lakedaemon.net>
 <20130528175343.77c6353d@skate>
 <20130528165401.GX31290@titan.lakedaemon.net>
 <51A50D0F.5010909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A50D0F.5010909@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:01:19PM +0200, Sebastian Hesselbarth wrote:
> On 05/28/2013 06:54 PM, Jason Cooper wrote:
> >>On Tue, 28 May 2013 11:40:47 -0400, Jason Cooper wrote:
> >>>I'm posting the revised version as replies to patches 1, 5 and 6. Please
> >>>let me know if I messed it up.  I'd like to send the PR for these
> >>>shortly.
> >
> >$ git checkout v3.10-rc3
> >$ git merge mvebu/of_pci
> >$ git merge mvebu/pcie
> >$ git merge mvebu/seb_clk
> 
> After manually resolving a merge conflict in arch/arm/mach-mvebu/Kconfig
> I can see no obvious regression on neither Dove nor Kirkwood.

Great, thanks, Sebastian!

Jason.
