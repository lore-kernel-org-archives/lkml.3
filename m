Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab3HZKKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:10:44 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50278 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab3HZKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:10:43 -0400
Date: Mon, 26 Aug 2013 18:06:36 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] arm: mvebu: add missing of_node_put() to fix
 reference leak
Message-ID: <20130826180636.3e2bdb20@xhacker>
In-Reply-To: <20130826120200.2269ba82@skate>
References: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
	<1377510981-1793-2-git-send-email-jszhang@marvell.com>
	<20130826120200.2269ba82@skate>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,

On Mon, 26 Aug 2013 03:02:00 -0700
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> Dear Jisheng Zhang,
> 
> On Mon, 26 Aug 2013 17:56:19 +0800, Jisheng Zhang wrote:
> 
> > diff --git a/arch/arm/mach-mvebu/armada-370-xp.c
> > b/arch/arm/mach-mvebu/armada-370-xp.c index 97cbb80..8a1ae83 100644
> > --- a/arch/arm/mach-mvebu/armada-370-xp.c
> > +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> > @@ -64,6 +64,7 @@ static void __init armada_370_xp_mbus_init(void)
> >  			ARMADA_370_XP_MBUS_WINS_SIZE,
> >  			of_translate_address(dn, &sdram_wins_offs),
> >  			ARMADA_370_XP_SDRAM_WINS_SIZE);
> > +	of_node_put(dn);
> >  }
> 
> With the integration of Ezequiel patches that add DT support to the
> mvebu-mbus driver, this chunk of the code is no longer needed, as of
> linux-next.
> 
Got it. Thanks for the information. Will send v4 latter

Thanks,
Jisheng

