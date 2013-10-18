Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3JRQGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:06:21 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53486 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753369Ab3JRQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:06:19 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UyLHR9jHV0CDkouG4nAQS
Date: Fri, 18 Oct 2013 09:06:15 -0700
From: Tony Lindgren <tony@atomide.com>
To: Balaji T K <balajitk@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131018160615.GM15154@atomide.com>
References: <20131010162015.GC29913@atomide.com>
 <CACRpkdYF83ghUf60Wmrti53UJ1bWV30GW_P9GjWnsOcZHbsv+Q@mail.gmail.com>
 <5257BD3E.5000707@ti.com>
 <CACRpkdYJNaiAAHhYatd6g5_wVt0QEUxOvsk6nQn9o=_i5zfWrA@mail.gmail.com>
 <20131011154352.GO29913@atomide.com>
 <CACRpkdZhbadd5d4P+2B0_DktqK4CHzZPVJC8kPHZYUnp8TaxsA@mail.gmail.com>
 <20131011160146.GR29913@atomide.com>
 <5260E606.2030903@ti.com>
 <20131018153541.GJ15154@atomide.com>
 <52615AD4.7040306@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52615AD4.7040306@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balaji T K <balajitk@ti.com> [131018 08:59]:
> On Friday 18 October 2013 09:05 PM, Tony Lindgren wrote:
> >* Balaji T K <balajitk@ti.com> [131018 00:41]:
> >>
> >>Any conclusion on using regmap for omap control module non-mux registers ?
> >
> >I don't think anybody has even started looking into a SCM driver
> >yet considering there are tons of other issues to sort out.
> >
> >If you're thinking about implementing the MMC PBIAS driver, I would
> >just implement it as a standalone driver. It seems that the PBIAS
> >interface to the MMC driver can be just regulator framework.
> >
> Hi Tony,
> 
> I am testing pbias regulator, Just thinking whether it should be
> using regmap api or direct readl/writel

OK either or should work. It seems that can easily be changed
later on though.
 
> >Then when we have the SCM driver available, this driver can be
> >updated to coordinate things with the core SCM driver.
> 
> Do you see regmap getting used for the SCM driver ?

Yes eventually :)

Tony
