Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaETAfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:35:50 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58450 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETAfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:35:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Ru5VlOHayMVo6LRgROeo5
Date: Mon, 19 May 2014 17:35:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv5 09/10] DTS: ARM: OMAP3-N900: Add SSI support
Message-ID: <20140520003538.GD15793@atomide.com>
References: <1399739870-13526-1-git-send-email-sre@kernel.org>
 <1399739870-13526-10-git-send-email-sre@kernel.org>
 <20140514215503.GM27426@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514215503.GM27426@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [140514 14:57]:
> * Sebastian Reichel <sre@kernel.org> [140510 09:40]:
> > Add SSI device tree data for OMAP3 and Nokia N900.
> 
> Picking this patch into omap-for-v3.16/dt thanks.

Just noticed that this patch seems to somehow break idle
modes on n900, so dropping both dts changes for now.

Basically the n900 debug LEDs won't ever go off with
these two dts patches enabled, even without the modem
drivers loaded. I did not dig deeper, but it's probably
something related to hwmod using this data for some
settings.

Sorry did not notice it earlier as I did not have the
PM regression fix patches merged with my testing branch.

Regards,

Tony
