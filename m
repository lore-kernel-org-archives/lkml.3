Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3HQBFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 21:05:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53631 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3HQBFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 21:05:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IQNCOL+8hw8jOQ0oQnj0U3NglciOdJG8=
Date: Fri, 16 Aug 2013 16:22:16 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 4/5] ARM: mvebu: add Armada 1500 and Sony NSZ-GS7
 device tree files
Message-ID: <20130816202216.GV13964@titan.lakedaemon.net>
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376682098-10580-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 09:41:37PM +0200, Sebastian Hesselbarth wrote:
> This adds very basic device tree files for the Marvell Armada 1500 SoC
> and the Sony NSZ-GS7 GoogleTV board. Currently, SoC only has nodes for
> cpus, some clocks, l2 cache controller, local timer, apb timers, uart,
> and interrupt controllers.
> 
> The clocks are fixed-clock placeholders until a real DT clock provider
> is available. Cache controller node may be wrong and was just guessed
> out of Armada 370 and GPL'd 1500 source. Timers except clocksource have
> not really been tested.
> 
> The separation into soc/apb and soc/sm-apb may be removed, but it looks
> like Armada 1500 has a separate peripheral bus for the System Manager
> core that can also been accessed by CPUs. (If you look closely on GTV
> boot logs, you can see SM and CPU fighting for UART ;) )
> 
> The Sony NSZ-GS7 is a GoogleTV consumer device comprising the SoC above.
> Since last week or so, there is a way to install a custom u-boot and
> boot stock, unsigned kernels easily. Just ask Google about it, if you
> are willing to void your warranty.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/Makefile                     |    3 +-
>  arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts |   29 +++
>  arch/arm/boot/dts/armada-1500.dtsi             |  225 ++++++++++++++++++++++++
>  3 files changed, 256 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/armada-1500-sony-nsz-gs7.dts
>  create mode 100644 arch/arm/boot/dts/armada-1500.dtsi

Also, binding docs?

thx,

Jason.
