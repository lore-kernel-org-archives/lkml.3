Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202AbaLPTVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:21:44 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:47872 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLPTVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:21:43 -0500
Date: Tue, 16 Dec 2014 20:20:20 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Evgeni Dobrev <evgeni@studio-punkt.com>
Cc: Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: kirkwood: add dts support for Seagate
 BlackArmor NAS220
Message-ID: <20141216192020.GB12820@lunn.ch>
References: <20141215203855.GA28940@anne>
 <20141216085645.GB1450@lunn.ch>
 <20141216163714.GE20170@anne>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216163714.GE20170@anne>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The LED can be either one of the two colors or off. Swapping the
> polarity on the two LED pins changes the color.

O.K, so it is using the diode property of a Light Emitting Diode, to
support two colours.

> I am currently playing with the idea to create a multicolor LED kernel 
> driver which is being controlled via GPIOs, but I still have not found 
> the proper abstraction for it.

Maybe multi-colour is too far. Just support bi-colour via two gpios.
Still, it is not so simple. As you said, the led class does not give
too good an abstraction. I guess the best you can do is that when you
turn one on, it automagically turns the other off.

> The point is, that even though this functionality must currently be
> handled by user space (some combination of sysfs writes and a shell
> script) at the moment, the rest of the system is usable.

Sure, we will take the DT file without support for the bicolour
LED. It can be added later.

      Andrew
 
