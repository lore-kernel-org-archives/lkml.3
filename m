Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaCNKgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 06:36:43 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:54593 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaCNKgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 06:36:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140313091234.GC9494@amd.pavel.ucw.cz>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
	<1392875640-29230-3-git-send-email-jenny.tc@intel.com>
	<CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
	<20140228100114.GA13189@amd.pavel.ucw.cz>
	<CACRpkdaZ2moqGWx2BpfEeKoW6doXg67TkJKY+mbg4hrFHDr16Q@mail.gmail.com>
	<20140307201039.GB27645@amd.pavel.ucw.cz>
	<CACRpkda_9UG70G-b3eGTccr22WC4eoAbj0g2QgX0DRSYVgvrxA@mail.gmail.com>
	<20140313091234.GC9494@amd.pavel.ucw.cz>
Date: Fri, 14 Mar 2014 11:36:40 +0100
Message-ID: <CACRpkda6VOStrazzMXXUFOQZsr1P0amVdyzLQ_wTHXmshsV2=A@mail.gmail.com>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Pavel Machek <pavel@ucw.cz>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Jenny TC <jenny.tc@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:12 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > 30*HZ means 30 seconds in the kernel... what is hard to understand
>> > about it?
>>
>> Well I might be picky, but since it is a charging algorithm dealing with
>> ampères, volts, constant-current/constant-voltage, watchdogs and
>> timeouts, all stated in SI units, it would be nice if all such constants
>> were specified in simple units instead of kernel-specific terms.
>
> I agree HZ is badly named, but hopefully anyone working on kernel is
> already familiar with it.
>
> But... what would actually help: I believe we should introduce
> milivolt_t, miliamp_t, milisec_t etc... types. Storing milivolts in
> int, then having comment saying "milivolts" is just wrong.

Hm! I bet the regulator subsystem maintainers have opinions
on that.

Yours,
Linus Walleij
