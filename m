Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428Ab3DAQZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:25:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:36150 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754205Ab3DAQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:25:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/zR6WhmGAtuM6cS8UFRTXa
Date: Mon, 1 Apr 2013 09:25:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>,
        Russell King <linux@arm.linux.org.uk>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Subject: Re: [PATCH] OMAP3 ROM Random Number Generator support
Message-ID: <20130401162536.GG10155@atomide.com>
References: <201302281905.48546@pali>
 <201303281854.02847@pali>
 <20130328214411.GZ10155@atomide.com>
 <201303311128.12698@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303311128.12698@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130331 02:32]:
> On Thursday 28 March 2013 22:44:11 Tony Lindgren wrote:
> > 
> > You can use regular clk_get if you add the alias to
> > struct omap_clk omap3xxx_clks table.
> 
> Tony, can you show me how?

Take a look at the omap3xxx_clks in cclock3xxx_data.c.
Note how some entries have things like "omap_hsmmc.0" and
"ick". By adding those your driver can request the clock
with clk_get(&pdev->dev, "ick").

Regards,

Tony
