Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaFWVuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:50:37 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:34793 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752396AbaFWVuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:50:35 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/sB3r5gk9B3MV7nGxGO2dFNLLCyllq4kQ=
X-DKIM: OpenDKIM Filter v2.0.1 titan 5F5E7597BD2
Date: Mon, 23 Jun 2014 17:50:15 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: kirkwood: fix phy-connection-type for
 Guruplug
Message-ID: <20140623215015.GC10202@titan.lakedaemon.net>
References: <1403555115-13111-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403555115-13111-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:25:15PM +0200, Sebastian Hesselbarth wrote:
> Commit eeb845459a72e792a959278b858f9c417e9995bd
>  ("ARM: dts: kirkwood: set Guruplug phy-connection-type to rgmii-id")
> added phy-connection-type properties to ethernet PHY nodes.
> 
> Actually, the property has to be set for the ethernet port node instead.
> Fix it by moving the corresponding properties to the correct nodes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Jason,
> 
> this should go in as a fix for v3.16 where above commit appeared first.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/kirkwood-guruplug-server-plus.dts | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to mvebu/fixes

thx,

Jason.
