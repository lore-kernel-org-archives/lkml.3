Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3HAVGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:06:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39683 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3HAVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:06:50 -0400
Date: Thu, 1 Aug 2013 22:06:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, Olof Johansson <olof@lixom.net>,
        Sam Creasey <sammy@sammy.net>,
        Grant Grundler <grundler@parisc-linux.org>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Network Development <netdev@vger.kernel.org>,
        Sony Chacko <sony.chacko@qlogic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Don Fry <pcnet32@frontier.com>, Ron Mercer <ron.mercer@qlogic.com>,
        Andrew Gallatin <gallatin@myri.com>, linux-driver@qlogic.com,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>
Subject: Re: [PATCH V2 3/3] ethernet: Convert mac address uses of 6 to
	ETH_ALEN
Message-ID: <20130801210618.GK23006@n2100.arm.linux.org.uk>
References: <cover.1375387593.git.joe@perches.com> <4170130535e4ea14c66f8510042577be21941f4d.1375387593.git.joe@perches.com> <CAOesGMhmxJTDjcPeD4b1FvRsbP8df369F01SQBK6dk4nXmRGjA@mail.gmail.com> <20130801203343.GG23006@n2100.arm.linux.org.uk> <1375390528.2034.77.camel@joe-AO722> <20130801205817.GJ23006@n2100.arm.linux.org.uk> <1375391087.2034.82.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375391087.2034.82.camel@joe-AO722>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 02:04:47PM -0700, Joe Perches wrote:
> On Thu, 2013-08-01 at 21:58 +0100, Russell King - ARM Linux wrote:
> > This seems rather obscure - I mean, it's not obvious to driver authors
> > that should be the case.  Would it not be better to make this a little
> > more obvious somehow?  Maybe __aligned(2) against mac_addr?  Or
> > maybe have a debugging check for it?
> 
> That'd be for David Miller (cc'd).
> 
> I believe he's argued in the past that any alignment check
> for mac addresses was unnecessary.
> 
> For all I know it really might not matter because pasemi
> can successfully dereference a ushort against an odd char
> pointer.
> 
> I just noticed it and thought it'd be better moved.

As can ARM too for years now - either in hardware or via fixup for
kernel code.
