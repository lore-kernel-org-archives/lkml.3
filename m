Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbaCMJMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:12:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55333 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaCMJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:12:37 -0400
Date: Thu, 13 Mar 2014 10:12:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jenny TC <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140313091234.GC9494@amd.pavel.ucw.cz>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
 <1392875640-29230-3-git-send-email-jenny.tc@intel.com>
 <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
 <20140228100114.GA13189@amd.pavel.ucw.cz>
 <CACRpkdaZ2moqGWx2BpfEeKoW6doXg67TkJKY+mbg4hrFHDr16Q@mail.gmail.com>
 <20140307201039.GB27645@amd.pavel.ucw.cz>
 <CACRpkda_9UG70G-b3eGTccr22WC4eoAbj0g2QgX0DRSYVgvrxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda_9UG70G-b3eGTccr22WC4eoAbj0g2QgX0DRSYVgvrxA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 30*HZ means 30 seconds in the kernel... what is hard to understand
> > about it?
> 
> Well I might be picky, but since it is a charging algorithm dealing with
> ampères, volts, constant-current/constant-voltage, watchdogs and
> timeouts, all stated in SI units, it would be nice if all such constants
> were specified in simple units instead of kernel-specific terms.

I agree HZ is badly named, but hopefully anyone working on kernel is
already familiar with it.

But... what would actually help: I believe we should introduce
milivolt_t, miliamp_t, milisec_t etc... types. Storing milivolts in
int, then having comment saying "milivolts" is just wrong.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
