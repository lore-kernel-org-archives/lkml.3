Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3DPEqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 00:46:02 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46290 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3DPEqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 00:46:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130416105513.913219ac889b1db952876197@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Dom Cobley <popcornmix@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabeeh Khoury <rabeeh@solid-run.com>, Daniel Mack <zonque@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Michal Bachraty <michal.bachraty@streamunlimited.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1366009214-32234-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130416105513.913219ac889b1db952876197@canb.auug.org.au>
Message-ID: <20130416044514.19887.93969@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] clk: si5351: make clk-si5351 depend on CONFIG_OF
Date: Mon, 15 Apr 2013 21:45:14 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2013-04-15 17:55:13)
> Hi Sebastian,
> 
> On Mon, 15 Apr 2013 09:00:14 +0200 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
> >
> > Calling clk-si5351 driver non-OF ready was too early. This patch
> > makes clk-si5351 depend on CONFIG_OF again, until things get sorted out.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > Reported-by: Stephen Rottweil <sfr@canb.auug.org.au>
> 
> My name is spelt "Rothwell" (as in the Cc: line below) :-(
> 

It's fixed in the merged version.

Regards,
Mike

> > ---
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
