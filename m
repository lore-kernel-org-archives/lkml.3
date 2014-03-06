Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaCFUSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:18:06 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34902 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752487AbaCFUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:18:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/3AD/VHSSdS+NSpqrwsuseMPRW5iOu8Qw=
X-DKIM: OpenDKIM Filter v2.0.1 titan B2DDD53C249
Date: Thu, 6 Mar 2014 15:17:28 -0500
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
Subject: Re: [PATCH 2/3] devicetree: bindings: drop pinctrl PMU reg property
Message-ID: <20140306201728.GK1872@titan.lakedaemon.net>
References: <1393977790-29110-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393977790-29110-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393977790-29110-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:03:09AM +0100, Sebastian Hesselbarth wrote:
> Marvell Dove's pinctrl does require some PMU regs for muxing PMU
> functions to MPP pins. Recently, a discussion started about consolidating
> Power Management Unit (PMU) into a single DT node. As we don't want
> anymore DT ABI in the way, drop the corresponding reg property from
> pinctrl binding documentation now.
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
>  Documentation/devicetree/bindings/pinctrl/marvell,dove-pinctrl.txt  | 2 +-
>  Documentation/devicetree/bindings/pinctrl/marvell,mvebu-pinctrl.txt | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied to mvebu/pinctrl

thx,

Jason.
