Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab3ITSb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:31:57 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:30250 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3ITSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:31:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/kUgfZF47ViG5XH46K78Iv
Date: Fri, 20 Sep 2013 11:31:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] omap2: Change clk dev id for rng to
 omap3-rom-rng
Message-ID: <20130920183144.GB2684@atomide.com>
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <201309201841.16197@pali>
 <20130920174640.GA2684@atomide.com>
 <201309202024.50755@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309202024.50755@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130920 11:32]:
> On Friday 20 September 2013 19:46:41 Tony Lindgren wrote:
> 
> Ok, then there is new patch which only adding omap3-rom-rng and not removing omap_rng.
> It is OK to have same CLK data but with different names?

Yes in this case it's always either omap_rng or omap3-rom-rng
so the patch below looks OK to me.

Regards,

Tony
 
> diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
> index 334b767..03a2829 100644
> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> @@ -3275,6 +3275,7 @@ static struct omap_clk omap36xx_clks[] = {
>  static struct omap_clk omap34xx_omap36xx_clks[] = {
>  	CLK(NULL,	"aes1_ick",	&aes1_ick),
>  	CLK("omap_rng",	"ick",		&rng_ick),
> +	CLK("omap3-rom-rng",	"ick",	&rng_ick),
>  	CLK(NULL,	"sha11_ick",	&sha11_ick),
>  	CLK(NULL,	"des1_ick",	&des1_ick),
>  	CLK(NULL,	"cam_mclk",	&cam_mclk),
> 
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com


