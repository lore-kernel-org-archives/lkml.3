Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbaD3TrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:47:23 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64981 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbaD3TrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:47:22 -0400
Message-ID: <53615342.8010600@gmail.com>
Date: Wed, 30 Apr 2014 21:47:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/15] ARM: dts: kirkwood: add stdout-path property to
 all boards
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com> <1398862602-29595-4-git-send-email-sebastian.hesselbarth@gmail.com> <20140430163807.GA3082@lunn.ch>
In-Reply-To: <20140430163807.GA3082@lunn.ch>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 06:38 PM, Andrew Lunn wrote:
> On Wed, Apr 30, 2014 at 02:56:30PM +0200, Sebastian Hesselbarth wrote:
>> ePAPR allows to reference the device used for console output by
>> stdout-path property. With node labels for Kirkwood UART0, now
>> reference it on all Kirkwood boards that already have ttyS0 in
>> their bootargs property.
> 
> Could this be done in kirkwood.dtsi. I don't think we have any board
> using ttyS1 for console, and if one does come along, it should be able
> to override it.

Yes, we *can* move it in kirkwood.dtsi, but IMHO we *should* keep it in
the board files. I see the "chosen" node and its properties as _the_
board node.

One could argue then, that we should count the memory properties too and
put the most common in the SoC dtsi. But you are right, as UART0 is also
the UART with boot support, it is likely to be always connected to
a more-or-less accessible console output.

I really have no strong opinion about it.

Sebastian

