Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbaD3UbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:31:14 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53790 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759296AbaD3UbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:31:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/15] ARM: dts: kirkwood: add stdout-path property to all boards
Date: Wed, 30 Apr 2014 22:30:21 +0200
Message-ID: <142642785.6KSg8q4tJP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140430202130.GE3082@lunn.ch>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com> <53615342.8010600@gmail.com> <20140430202130.GE3082@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:8cCvyX//wAjTRDl1x5tnZNhVrXtCHZK2bumXNkTW1pV
 +8kPDOFoimGSLK4HXvtb95mh/TD3CFPMz4pCI8a7oQYeYqoe31
 XPTFZnzAJkJXo5snCr8qguYbaPdhxHJ90hYEmTHoh/kiKo+jSE
 agu3fXHPcuidND+x+8vD0QwDbCFgI9PVwQXzN/LBWIcl+xxTez
 GMS/irMcliw+vr2JbXRWWNdV1ByU4/bnzMcErEnPehbg16BjBD
 XQ11b22pIT1G1u1NqjnO3tXDq+XB8w+8NpR2FFja/PebcfKs20
 Btn308WRienyxYpSkie5wGLBPCE5ZdJi6lwHmLTcbDhYWJehR3
 DupZrTWIXyfXM4IsZVm8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2014 22:21:30 Andrew Lunn wrote:
> > Yes, we *can* move it in kirkwood.dtsi, but IMHO we *should* keep it in
> > the board files. I see the "chosen" node and its properties as _the_
> > board node.
> > 
> > One could argue then, that we should count the memory properties too and
> > put the most common in the SoC dtsi. But you are right, as UART0 is also
> > the UART with boot support, it is likely to be always connected to
> > a more-or-less accessible console output.
> > 
> > I really have no strong opinion about it.
> 
> Me neithe, but the advantage of putting it in kirkwood.dtsi is that it
> then does not get forgotten, and is always there for bearbox to use.

I would prefer having it in the board.dts file out of principle, but I
agree it's not very important either way.

	Arnd
