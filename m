Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbaD3UYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:24:21 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:35939 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758905AbaD3UYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:24:20 -0400
Date: Wed, 30 Apr 2014 22:21:30 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Mark Rutland <mark.rutland@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/15] ARM: dts: kirkwood: add stdout-path property to
 all boards
Message-ID: <20140430202130.GE3082@lunn.ch>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1398862602-29595-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140430163807.GA3082@lunn.ch>
 <53615342.8010600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53615342.8010600@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, we *can* move it in kirkwood.dtsi, but IMHO we *should* keep it in
> the board files. I see the "chosen" node and its properties as _the_
> board node.
> 
> One could argue then, that we should count the memory properties too and
> put the most common in the SoC dtsi. But you are right, as UART0 is also
> the UART with boot support, it is likely to be always connected to
> a more-or-less accessible console output.
> 
> I really have no strong opinion about it.

Me neithe, but the advantage of putting it in kirkwood.dtsi is that it
then does not get forgotten, and is always there for bearbox to use.

    Andrew
