Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaCFUPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:15:34 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:29632 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbaCFUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:15:32 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/1ReTUoLonYgruw/NPrE6wtWRqtv2W2us=
X-DKIM: OpenDKIM Filter v2.0.1 titan D9E6153C21C
Date: Thu, 6 Mar 2014 15:15:10 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: dove: drop pinctrl PMU reg property
Message-ID: <20140306201510.GJ1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393977790-29110-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393977790-29110-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:03:08AM +0100, Sebastian Hesselbarth wrote:
> Marvell Dove's pinctrl does require some PMU regs for muxing PMU
> functions to MPP pins. Recently, a discussion started about consolidating
> Power Management Unit (PMU) into a single DT node. As we don't want
> anymore DT ABI in the way, drop the corresponding reg property from
> pinctrl node now. The driver will derive the registers from existing
> reg properties.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Rob Herring <robh+dt@kernel.org> 
> Cc: Pawel Moll <pawel.moll@arm.com> 
> Cc: Mark Rutland <mark.rutland@arm.com> 
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk> 
> Cc: Kumar Gala <galak@codeaurora.org> 
> Cc: Russell King <linux@arm.linux.org.uk> 
> Cc: Jason Cooper <jason@lakedaemon.net> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: devicetree@vger.kernel.org 
> Cc: linux-arm-kernel@lists.infradead.org 
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove.dtsi | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to mvebu/dt

thx,

Jason.
