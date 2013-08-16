Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3HPP7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:59:49 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39630 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3HPP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:59:46 -0400
Date: Fri, 16 Aug 2013 08:59:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Michael Brunner <mibru@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] gpio: Fix bit masking in Kontron PLD GPIO driver
Message-ID: <20130816155943.GC6953@roeck-us.net>
References: <20130809173326.75aed3b6@mail.gmx.de>
 <CACRpkdYe9+Fb-YO4Mn885YtY_YiRWsG1U+sFXo-poThpDOL1dw@mail.gmail.com>
 <20130816155156.GA6953@roeck-us.net>
 <CACRpkdaxdkriaO-ufq6JSFONecBRHYstfnUBojGOwQfBaXb8ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaxdkriaO-ufq6JSFONecBRHYstfnUBojGOwQfBaXb8ZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 05:58:02PM +0200, Linus Walleij wrote:
> On Fri, Aug 16, 2013 at 5:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > I think Michael just went on vacation.
> >
> > Clean version is below. He must have sent it to me separately
> > because it worked for me.
> 
> Yeah this worked fine ... strange.
> 
Probably there is some outlook server in the path :(

Guenter
