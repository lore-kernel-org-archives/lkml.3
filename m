Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaCDEaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:30:06 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50963 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755944AbaCDEaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:30:03 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Cd1MvyMDQlw3Tm957HBl/dPML9gGfggY=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1C7DE53924C
Date: Mon, 3 Mar 2014 23:29:42 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] ARM: mvebu: move DT Dove to MVEBU
Message-ID: <20140304042942.GK1872@titan.lakedaemon.net>
References: <1393538613-28293-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393663178-22120-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393663178-22120-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 09:39:38AM +0100, Sebastian Hesselbarth wrote:
> With all the DT support preparation done, we are able to move Dove
> to MVEBU easily. Legacy non-DT mach-dove is left untouched to rot
> for a while before removal.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v1->v2:
> - just rename CONFIG_ARCH_DOVE to CONFIG_MACH_DOVE in dts/Makefile
>   (Suggested by Jason Cooper)
> v2->v3:
> - dropped drivers/phy/Kconfig change, which is now an individual
>   patch sent to Kishon.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/Makefile    |  2 +-
>  arch/arm/mach-dove/Kconfig    | 12 ------------
>  arch/arm/mach-dove/Makefile   |  1 -
>  arch/arm/mach-dove/board-dt.c | 43 -------------------------------------------
>  arch/arm/mach-mvebu/Kconfig   | 12 ++++++++++++
>  arch/arm/mach-mvebu/Makefile  |  1 +
>  arch/arm/mach-mvebu/dove.c    | 39 +++++++++++++++++++++++++++++++++++++++
>  7 files changed, 53 insertions(+), 57 deletions(-)
>  delete mode 100644 arch/arm/mach-dove/board-dt.c
>  create mode 100644 arch/arm/mach-mvebu/dove.c

We'll see how it goes!

Applied to mvebu/soc

thx,

Jason.
